#Requires -Version 5.1
<#
Install the published Windows suite from the signed public marketplace as a
standard ContainerUser. Modes run in separate PowerShell processes.
#>
param(
    [Parameter(Mandatory = $true)][string]$WorkRoot,
    [Parameter(Mandatory = $true)][string]$ExpectedTag,
    [Parameter(Mandatory = $true)][ValidateSet('install', 'readback', 'uninstall')][string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$version = $ExpectedTag.TrimStart('v')
$archive = Join-Path $WorkRoot 'suite.zip'
$expanded = Join-Path $WorkRoot 'marketplace-archive'
$userRoot = Join-Path $WorkRoot 'marketplace-user'
$installerHome = Join-Path $userRoot 'installer'
$binDir = Join-Path $installerHome 'bin'
$bootstrap = Join-Path $WorkRoot 'marketplace-bootstrap\festival.exe'
$managed = Join-Path $binDir 'festival.exe'
$hashesPath = Join-Path $WorkRoot 'marketplace-hashes.json'
$workspace = Join-Path $WorkRoot 'workspace'
$campRoot = Join-Path $workspace 'public-proof'
$sentinel = Join-Path $workspace 'keep-this-camp.txt'
$scoopRoot = Join-Path $WorkRoot 'scoop'
$env:HOME = $userRoot
$env:USERPROFILE = $userRoot
$env:FESTIVAL_HOME = $installerHome
$env:TEMP = Join-Path $userRoot 'tmp'
$env:TMP = $env:TEMP
$env:PATH = "$binDir;$(Join-Path $scoopRoot 'shims');$env:PATH"
$env:NO_COLOR = '1'

function Assert-File([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "missing file: $Path" }
}

function Assert-Workspace {
    Assert-File $sentinel
    if ([IO.File]::ReadAllText($sentinel) -ne 'user workspace survives Scoop lifecycle' -or
        -not (Test-Path -LiteralPath (Join-Path $campRoot '.campaign\campaign.yaml') -PathType Leaf) -or
        -not (Test-Path -LiteralPath (Join-Path $campRoot '.git\HEAD') -PathType Leaf)) {
        throw 'Public marketplace install changed the independent camp workspace'
    }
}

function Invoke-Festival([string]$Executable, [string[]]$CommandArgs) {
    $stdoutPath = Join-Path $WorkRoot 'marketplace-command-stdout.txt'
    $stderrPath = Join-Path $WorkRoot 'marketplace-command-stderr.txt'
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & $Executable @CommandArgs 1> $stdoutPath 2> $stderrPath
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }
    $output = Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue
    $stderr = Get-Content -LiteralPath $stderrPath -Raw -ErrorAction SilentlyContinue
    Write-Host "festival $($CommandArgs -join ' ') => $code"
    if ($stderr) { Write-Host "stderr: $stderr" }
    if ($code -ne 0) { throw "festival command failed ($code): $($CommandArgs -join ' ')`n$output`n$stderr" }
    return $output
}

function Invoke-JsonFestival([string]$Executable, [string[]]$CommandArgs) {
    $output = Invoke-Festival -Executable $Executable -CommandArgs $CommandArgs
    $doc = $output | ConvertFrom-Json
    if (-not $doc.ok) { throw "Festival returned a failed JSON response: $output" }
    return $doc.data
}

function Assert-Installed {
    Assert-Workspace
    $expected = Get-Content -LiteralPath $hashesPath -Raw | ConvertFrom-Json
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        $path = Join-Path $binDir $name
        Assert-File $path
        $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $expected.$name) { throw "Public marketplace $name hash mismatch" }
        & $path version | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "Public marketplace $name cannot run" }
    }
    $inventory = Invoke-JsonFestival -Executable $managed -CommandArgs @('list', '--json')
    $packages = @($inventory.packages)
    if ($packages.Count -ne 1 -or $packages[0].package_id -ne 'obedience-corp/festival' -or
        $packages[0].version -ne $version -or @($packages[0].files).Count -ne 3) {
        throw "Public marketplace receipt is wrong: $($inventory | ConvertTo-Json -Depth 8)"
    }
    $doctor = Invoke-JsonFestival -Executable $managed -CommandArgs @('doctor', '--json')
    $checks = @{}
    foreach ($check in @($doctor.checks)) { $checks[[string]$check.id] = [string]$check.status }
    foreach ($id in @('receipts_integrity', 'marketplace_trust', 'sources_reachable')) {
        if ($checks[$id] -ne 'ok') { throw "Public marketplace doctor $id is $($checks[$id])" }
    }
}

[void][IO.Directory]::CreateDirectory($env:TEMP)
switch ($Mode) {
    'install' {
        Assert-File $archive
        Assert-Workspace
        Expand-Archive -LiteralPath $archive -DestinationPath $expanded
        [void][IO.Directory]::CreateDirectory((Split-Path -Parent $bootstrap))
        [void][IO.Directory]::CreateDirectory($binDir)
        [IO.File]::Copy((Join-Path $expanded 'festival.exe'), $bootstrap, $true)
        [IO.File]::Copy($bootstrap, $managed, $true)
        $hashes = @{}
        foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
            $path = Join-Path $expanded $name
            Assert-File $path
            $hashes[$name] = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
        }
        [IO.File]::WriteAllText($hashesPath, ($hashes | ConvertTo-Json),
            (New-Object Text.UTF8Encoding($false)))
        [IO.File]::WriteAllText((Join-Path $installerHome 'config.toml'),
            "[marketplaces]`ndefault = 'obedience'`n")
        Invoke-Festival -Executable $bootstrap -CommandArgs @('marketplace', 'add',
            'https://github.com/Obedience-Corp/marketplace.git', '--name', 'obedience') | Out-Null
        $result = Invoke-JsonFestival -Executable $managed -CommandArgs @('install', 'festival', '--json')
        if ($result.version -ne $version -or @($result.files).Count -ne 3) {
            throw "Public marketplace installed the wrong release: $($result | ConvertTo-Json -Depth 8)"
        }
        Assert-Installed
        Write-Host 'Windows public marketplace install: PASS'
    }
    'readback' {
        Assert-Installed
        Invoke-Festival -Executable $managed -CommandArgs @('update', 'festival', '--json') | Out-Null
        Assert-Installed
        Write-Host 'Windows public marketplace readback: PASS'
    }
    'uninstall' {
        Assert-Installed
        $removed = Invoke-JsonFestival -Executable $bootstrap -CommandArgs @('uninstall', 'festival', '--json')
        if (@($removed.removed).Count -ne 3) {
            throw "Public marketplace uninstall did not remove three binaries: $($removed | ConvertTo-Json)"
        }
        foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
            if (Test-Path -LiteralPath (Join-Path $binDir $name)) { throw "Uninstall left $name" }
        }
        Assert-Workspace
        Write-Host 'Windows public marketplace uninstall: PASS'
    }
}
