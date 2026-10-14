#Requires -Version 5.1
param(
    [Parameter(Mandatory = $true)][string]$WorkRoot,
    [Parameter(Mandatory = $true)][string]$ExpectedCampCommit,
    [Parameter(Mandatory = $true)][string]$ExpectedFestCommit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$install = Join-Path $WorkRoot 'Install Folder [native]'
[System.IO.Directory]::CreateDirectory($install) | Out-Null
if ($PSVersionTable.PSVersion.Major -lt 6) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
}
[System.IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $WorkRoot 'suite.zip'), $install)

foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
    $binary = Join-Path $install $name
    if (-not (Test-Path -LiteralPath $binary -PathType Leaf)) {
        throw "$name missing after ZIP extraction"
    }
    $output = & $binary version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "$name version failed ($LASTEXITCODE): $($output | Out-String)"
    }
    $version = ($output | Out-String).Trim()
    if (-not $version) {
        throw "$name version produced no output"
    }
    Write-Host "$name version: $version"
}

foreach ($tool in @(
    @{ Name = 'camp'; Commit = $ExpectedCampCommit },
    @{ Name = 'fest'; Commit = $ExpectedFestCommit }
)) {
    $binary = Join-Path $install ($tool.Name + '.exe')
    $report = (& $binary version --json | Out-String | ConvertFrom-Json)
    if ($LASTEXITCODE -ne 0 -or $report.commit -ne $tool.Commit) {
        throw "$($tool.Name) reports commit $($report.commit), expected $($tool.Commit)"
    }
    if ($report.platform -ne 'windows/amd64' -or -not $report.bundle) {
        throw "$($tool.Name) has incorrect platform or missing suite bundle stamp"
    }
}

Write-Host "Windows suite archive container proof: PASS"
