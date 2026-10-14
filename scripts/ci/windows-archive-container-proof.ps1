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

$campCommit = (& git -C (Join-Path $repoRoot 'camp') rev-parse --short HEAD | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not $campCommit) { throw 'Cannot read pinned Camp commit' }
$festCommit = (& git -C (Join-Path $repoRoot 'fest') rev-parse --short HEAD | Out-String).Trim()
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

    $ps51 = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    $output = & docker exec -u ContainerUser $containerId $ps51 -NoProfile -NonInteractive `
        -ExecutionPolicy Bypass -File "${workRoot}\proof.ps1" -WorkRoot $workRoot `
        -ExpectedCampCommit $campCommit -ExpectedFestCommit $festCommit 2>&1
    $code = $LASTEXITCODE
    $message = $output | Out-String
    Write-Host $message
    if ($code -ne 0 -or $message -notmatch 'Windows suite archive container proof: PASS') {
        throw "Native Windows archive proof failed ($code)"
    }
} finally {
    if ($containerId) {
        Remove-ServerCoreContainer $containerId
    }
}
