#Requires -Version 7.0
<#
Run Scoop install, update, and uninstall against the candidate Windows ZIP in
an isolated Server Core container. The generated manifest is copied verbatim;
only its release URL is replaced with an in-container HTTP address for testing.
#>
param(
    [Parameter(Mandatory = $true)][string]$ArtifactDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
. (Join-Path $repoRoot 'fest/scripts/ci/windows-servercore-container.ps1')

$archives = @(Get-ChildItem -LiteralPath $ArtifactDirectory -Recurse -File -Filter 'festival-*-windows-x86_64.zip')
$manifests = @(Get-ChildItem -LiteralPath $ArtifactDirectory -Recurse -File -Filter 'festival.json')
if ($archives.Count -ne 1 -or $manifests.Count -ne 1) {
    throw "Expected one Windows ZIP and one generated Scoop manifest in $ArtifactDirectory"
}
$archive = $archives[0]
$manifest = $manifests[0]
$manifestData = Get-Content -LiteralPath $manifest.FullName -Raw | ConvertFrom-Json
$expectedHash = $manifestData.architecture.'64bit'.hash
$actualHash = (Get-FileHash -LiteralPath $archive.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
if ($expectedHash -ne $actualHash) {
    throw "Generated Scoop manifest hash does not match $($archive.Name)"
}
if ($manifestData.architecture.'64bit'.url -notlike "*/$($archive.Name)") {
    throw "Generated Scoop manifest URL does not end in $($archive.Name)"
}

$containerId = $null
try {
    Assert-WindowsProofHost
    Report-DockerServices
    Start-DockerServiceIfPresent
    Report-DockerCapability

    $containerId = New-ServerCoreIdleContainer
    $workRoot = 'C:\scoop-proof'
    Invoke-DockerExecAsAdmin $containerId "mkdir $workRoot" | Out-Null
    $userSid = Get-ContainerUserSid -ContainerId $containerId
    Grant-ContainerUserModify -ContainerId $containerId -ContainerPath $workRoot -UserSid $userSid

    Invoke-DockerCli -DockerArgs @('cp', $archive.FullName, "${containerId}:${workRoot}\suite.zip") | Out-Null
    Invoke-DockerCli -DockerArgs @('cp', $manifest.FullName, "${containerId}:${workRoot}\festival.json") | Out-Null
    $inner = Join-Path $PSScriptRoot 'windows-scoop-container-inner.ps1'
    Invoke-DockerCli -DockerArgs @('cp', $inner, "${containerId}:${workRoot}\proof.ps1") | Out-Null

    $ps51 = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    $output = & docker exec -u ContainerUser $containerId $ps51 -NoProfile -NonInteractive `
        -ExecutionPolicy Bypass -File "${workRoot}\proof.ps1" -WorkRoot $workRoot 2>&1
    $code = $LASTEXITCODE
    $message = $output | Out-String
    Write-Host $message
    if ($code -ne 0 -or $message -notmatch 'Windows Scoop container proof: PASS') {
        throw "Native Windows Scoop proof failed ($code)"
    }
} finally {
    if ($containerId) {
        Remove-ServerCoreContainer $containerId
    }
}
