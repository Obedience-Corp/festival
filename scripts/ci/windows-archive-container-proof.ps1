#Requires -Version 7.0
<#
Run the suite archive inside Windows Server Core as ContainerUser. The host only
downloads and copies the ZIP; extraction and executable launch stay isolated.
#>
param(
    [Parameter(Mandatory = $true)][string]$ArtifactDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
. (Join-Path $repoRoot 'fest/scripts/ci/windows-servercore-container.ps1')

$campCommit = (& git -C (Join-Path $repoRoot 'camp') rev-parse --short=12 HEAD | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not $campCommit) { throw 'Cannot read pinned Camp commit' }
$festCommit = (& git -C (Join-Path $repoRoot 'fest') rev-parse --short=12 HEAD | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not $festCommit) { throw 'Cannot read pinned Fest commit' }

$archive = @(Get-ChildItem -LiteralPath $ArtifactDirectory -Recurse -File -Filter 'festival-*-windows-x86_64.zip')
if ($archive.Count -ne 1) {
    throw "Expected one Windows x86_64 suite ZIP in $ArtifactDirectory, found $($archive.Count)"
}
$checksums = @(Get-ChildItem -LiteralPath $ArtifactDirectory -Recurse -File -Filter 'checksums.txt')
if ($checksums.Count -ne 1) {
    throw "Expected one checksums.txt in $ArtifactDirectory, found $($checksums.Count)"
}
$name = $archive[0].Name
$hashLines = @(Get-Content -LiteralPath $checksums[0].FullName | Where-Object { $_ -match "^[0-9a-fA-F]{64}  \*?$( [regex]::Escape($name) )$" })
if ($hashLines.Count -ne 1) {
    throw "Expected one SHA-256 entry for $name"
}
$expected = $hashLines[0].Substring(0, 64).ToLowerInvariant()
$actual = (Get-FileHash -LiteralPath $archive[0].FullName -Algorithm SHA256).Hash.ToLowerInvariant()
if ($expected -ne $actual) {
    throw "SHA-256 mismatch for $name"
}

function Get-HostGitRoot {
    $gitCmd = (Get-Command git.exe -ErrorAction Stop).Source
    for ($dir = Split-Path -Parent $gitCmd; $dir; $dir = Split-Path -Parent $dir) {
        if (Test-Path -LiteralPath (Join-Path $dir 'cmd\git.exe')) {
            return $dir
        }
        $parent = Split-Path -Parent $dir
        if ($parent -eq $dir) { break }
    }
    throw "host Git layout unexpected at $gitCmd (no parent with cmd\git.exe)"
}

function Invoke-ContainerProof([string]$ContainerId, [string]$ScriptPath, [string[]]$Arguments, [string]$PassMarker) {
    $ps51 = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    $output = & docker exec -u ContainerUser $ContainerId $ps51 -NoProfile -NonInteractive `
        -ExecutionPolicy Bypass -File $ScriptPath @Arguments 2>&1
    $code = $LASTEXITCODE
    $message = $output | Out-String
    Write-Host $message
    if ($code -ne 0 -or -not $message.Contains($PassMarker)) {
        throw "$ScriptPath failed ($code), required marker: $PassMarker"
    }
}

$containerId = $null
try {
    Assert-WindowsProofHost
    Report-DockerServices
    Start-DockerServiceIfPresent
    Report-DockerCapability

    $containerId = New-ServerCoreIdleContainer
    $workRoot = 'C:\suite-proof'
    Invoke-DockerExecAsAdmin $containerId "mkdir $workRoot" | Out-Null
    $userSid = Get-ContainerUserSid -ContainerId $containerId
    Grant-ContainerUserModify -ContainerId $containerId -ContainerPath $workRoot -UserSid $userSid

    Invoke-DockerCli -DockerArgs @('cp', $archive[0].FullName, "${containerId}:${workRoot}\suite.zip") | Out-Null
    $inner = Join-Path $PSScriptRoot 'windows-archive-container-inner.ps1'
    Invoke-DockerCli -DockerArgs @('cp', $inner, "${containerId}:${workRoot}\proof.ps1") | Out-Null

    $journey = Join-Path $PSScriptRoot 'windows-archive-container-journey-inner.ps1'
    Invoke-DockerCli -DockerArgs @('cp', $journey, "${containerId}:${workRoot}\journey.ps1") | Out-Null
    $gitRoot = Get-HostGitRoot
    Write-Host "Copying host Git from $gitRoot into isolated Windows container"
    Invoke-DockerCli -DockerArgs @('cp', $gitRoot, "${containerId}:${workRoot}\Git") | Out-Null

    Invoke-ContainerProof $containerId "${workRoot}\proof.ps1" `
        @('-WorkRoot', $workRoot, '-ExpectedCampCommit', $campCommit, '-ExpectedFestCommit', $festCommit) `
        'Windows suite archive container proof: PASS'
    Invoke-ContainerProof $containerId "${workRoot}\journey.ps1" `
        @('-WorkRoot', $workRoot, '-Mode', 'create') `
        'Windows installed beginner journey create: PASS'
    # This is a separate PowerShell process. It reads the saved camp, Git,
    # festival, task progress, and commit instead of trusting in-memory state.
    Invoke-ContainerProof $containerId "${workRoot}\journey.ps1" `
        @('-WorkRoot', $workRoot, '-Mode', 'readback') `
        'Windows installed beginner journey readback: PASS'
} finally {
    if ($containerId) {
        Remove-ServerCoreContainer $containerId
    }
}
