#Requires -Version 7.0
<#
Verify the published Scoop bucket using the documented commands in an
isolated Server Core container. The host downloads and verifies public assets;
all install, workspace, update, and uninstall mutations stay in the container.
#>
param(
    [Parameter(Mandatory = $true)][string]$ArtifactDirectory,
    [Parameter(Mandatory = $true)][string]$ExpectedTag
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
. (Join-Path $repoRoot 'fest/scripts/ci/windows-servercore-container.ps1')

$version = $ExpectedTag.TrimStart('v')
$manifestPath = Join-Path $ArtifactDirectory 'festival.json'
$archivePath = Join-Path $ArtifactDirectory "festival-$version-windows-x86_64.zip"
foreach ($path in @($manifestPath, $archivePath, (Join-Path $ArtifactDirectory 'checksums.txt'))) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Published Windows proof artifact missing: $path"
    }
}

$containerId = $null
try {
    Assert-WindowsProofHost
    Report-DockerServices
    Start-DockerServiceIfPresent
    Report-DockerCapability

    $containerId = New-ServerCoreIdleContainer
    $workRoot = 'C:\public-scoop-proof'
    Invoke-DockerExecAsAdmin $containerId "mkdir $workRoot" | Out-Null
    $userSid = Get-ContainerUserSid -ContainerId $containerId
    Grant-ContainerUserModify -ContainerId $containerId -ContainerPath $workRoot -UserSid $userSid

    Invoke-DockerCli -DockerArgs @('cp', $manifestPath, "${containerId}:${workRoot}\festival.json") | Out-Null
    $inner = Join-Path $PSScriptRoot 'windows-public-scoop-container-inner.ps1'
    Invoke-DockerCli -DockerArgs @('cp', $inner, "${containerId}:${workRoot}\proof.ps1") | Out-Null

    $ps51 = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    foreach ($mode in @('install', 'readback', 'uninstall')) {
        Write-Host "Public Scoop $mode as ContainerUser"
        $output = & docker exec -u ContainerUser $containerId $ps51 -NoProfile -NonInteractive `
            -ExecutionPolicy Bypass -File "${workRoot}\proof.ps1" `
            -WorkRoot $workRoot -ExpectedTag $ExpectedTag -Mode $mode 2>&1
        $code = $LASTEXITCODE
        $message = $output | Out-String
        Write-Host $message
        $marker = "Windows public Scoop ${mode}: PASS"
        if ($code -ne 0 -or -not $message.Contains($marker)) {
            throw "Public Scoop $mode failed ($code); expected marker: $marker"
        }
    }
} finally {
    if ($containerId) {
        Remove-ServerCoreContainer $containerId
    }
}
