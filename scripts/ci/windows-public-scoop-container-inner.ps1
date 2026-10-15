#Requires -Version 5.1
<#
Exercise the published bucket from a clean ContainerUser. Each mode runs in a
new PowerShell process, so readback proves that the install and camp state
survive beyond the process that created them.
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
$scoopRoot = Join-Path $WorkRoot 'scoop'
$workspace = Join-Path $WorkRoot 'workspace'
$campRoot = Join-Path $workspace 'public-proof'
$sentinel = Join-Path $workspace 'keep-this-camp.txt'
$scoop = Join-Path $scoopRoot 'apps\scoop\current\bin\scoop.ps1'
$env:SCOOP = $scoopRoot
$env:PATH = "$(Join-Path $scoopRoot 'shims');$env:PATH"
$env:GIT_AUTHOR_NAME = 'Windows Public Proof'
$env:GIT_AUTHOR_EMAIL = 'windows-proof@example.invalid'
$env:GIT_COMMITTER_NAME = $env:GIT_AUTHOR_NAME
$env:GIT_COMMITTER_EMAIL = $env:GIT_AUTHOR_EMAIL

function Invoke-Scoop([string[]]$Arguments) {
    $ps51 = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    & $ps51 -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $scoop @Arguments
    if ($LASTEXITCODE -ne 0) { throw "scoop $($Arguments -join ' ') failed ($LASTEXITCODE)" }
}

function Assert-Shims {
    foreach ($name in @('camp', 'fest', 'festival')) {
        $shim = Join-Path $scoopRoot "shims\$name.exe"
        if (-not (Test-Path -LiteralPath $shim -PathType Leaf)) { throw "$name Scoop shim is missing" }
        & $shim version | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "$name Scoop shim cannot run version" }
    }
}

function Assert-Workspace {
    if (-not (Test-Path -LiteralPath $sentinel -PathType Leaf) -or
        [IO.File]::ReadAllText($sentinel) -ne 'user workspace survives Scoop lifecycle') {
        throw 'Scoop lifecycle changed the user workspace sentinel'
    }
    if (-not (Test-Path -LiteralPath (Join-Path $campRoot '.campaign\campaign.yaml') -PathType Leaf) -or
        -not (Test-Path -LiteralPath (Join-Path $campRoot '.git\HEAD') -PathType Leaf)) {
        throw 'Created camp did not persist across Scoop lifecycle'
    }
}

switch ($Mode) {
    'install' {
        [void][IO.Directory]::CreateDirectory($workspace)
        [IO.File]::WriteAllText($sentinel, 'user workspace survives Scoop lifecycle')

        $bootstrap = Join-Path $WorkRoot 'scoop-install.ps1'
        Invoke-WebRequest -Uri 'https://get.scoop.sh' -UseBasicParsing -OutFile $bootstrap
        $ps51 = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
        & $ps51 -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $bootstrap -ScoopDir $scoopRoot
        if ($LASTEXITCODE -ne 0) { throw "Scoop bootstrap failed ($LASTEXITCODE)" }
        if (-not (Test-Path -LiteralPath $scoop -PathType Leaf)) { throw 'Scoop CLI missing after bootstrap' }

        Invoke-Scoop -Arguments @('install', 'git')
        Invoke-Scoop -Arguments @('bucket', 'add', 'obedience', 'https://github.com/Obedience-Corp/scoop-bucket')
        $bucketManifest = @(Get-ChildItem -LiteralPath (Join-Path $scoopRoot 'buckets\obedience') `
            -Recurse -File -Filter 'festival.json')
        if ($bucketManifest.Count -ne 1) { throw 'Scoop bucket did not contain one festival.json' }
        $localHash = (Get-FileHash -LiteralPath (Join-Path $WorkRoot 'festival.json') -Algorithm SHA256).Hash
        $bucketHash = (Get-FileHash -LiteralPath $bucketManifest[0].FullName -Algorithm SHA256).Hash
        if ($localHash -ne $bucketHash) { throw 'Cloned Scoop manifest differs from the verified public manifest' }

        Invoke-Scoop -Arguments @('install', 'obedience/festival')
        Assert-Shims
        $installed = Join-Path $scoopRoot "apps\festival\$version"
        if (-not (Test-Path -LiteralPath $installed -PathType Container)) {
            throw "Scoop did not install Festival $version"
        }
        $doctor = Join-Path $scoopRoot 'shims\festival.exe'
        & $doctor doctor | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "festival doctor failed ($LASTEXITCODE)" }

        $camp = Join-Path $scoopRoot 'shims\camp.exe'
        & $camp create public-proof --path $workspace `
            --description 'Public Windows Scoop proof' `
            --mission 'Preserve a camp across update and uninstall' | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "camp create failed ($LASTEXITCODE)" }
        Assert-Workspace
        Write-Host 'Windows public Scoop install: PASS'
    }
    'readback' {
        Assert-Shims
        Assert-Workspace
        $git = Join-Path $scoopRoot 'shims\git.exe'
        $head = (& $git -C $campRoot rev-parse HEAD | Out-String).Trim()
        if ($LASTEXITCODE -ne 0 -or -not $head) { throw 'Created camp Git HEAD cannot be read back' }
        $camp = Join-Path $scoopRoot 'shims\camp.exe'
        $listed = & $camp list | Out-String
        if ($LASTEXITCODE -ne 0 -or $listed -notmatch 'public-proof') {
            throw "Created camp is absent from fresh-process camp list: $listed"
        }
        Write-Host "Persisted camp HEAD: $head"
        Write-Host 'Windows public Scoop readback: PASS'
    }
    'uninstall' {
        Invoke-Scoop -Arguments @('update', 'festival')
        Assert-Shims
        Assert-Workspace
        Invoke-Scoop -Arguments @('uninstall', 'festival')
        if (Test-Path -LiteralPath (Join-Path $scoopRoot 'apps\festival\current')) {
            throw 'Scoop uninstall left the suite current link'
        }
        foreach ($name in @('camp', 'fest', 'festival')) {
            if (Test-Path -LiteralPath (Join-Path $scoopRoot "shims\$name.exe")) {
                throw "Scoop uninstall left the $name shim"
            }
        }
        Assert-Workspace
        Write-Host 'Windows public Scoop uninstall: PASS'
    }
}
