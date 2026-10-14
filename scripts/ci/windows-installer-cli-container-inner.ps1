#Requires -Version 5.1
<#
Drive the released Festival installer commands against the same Windows suite
ZIP that archive CI generated. The local marketplace is intentionally unsigned
and accepted with --allow-unverified; production signing is a separate gate.
Every write in this script stays inside the disposable Server Core container.
#>
param(
    [Parameter(Mandatory = $true)][string]$WorkRoot,
    [Parameter(Mandatory = $true)][ValidateSet('run', 'readback')][string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$archive = Join-Path $WorkRoot 'suite.zip'
$checksums = Join-Path $WorkRoot 'checksums.txt'
$gitCmd = Join-Path $WorkRoot 'Git\cmd'
$gitMingw = Join-Path $WorkRoot 'Git\mingw64\bin'
$gitUsr = Join-Path $WorkRoot 'Git\usr\bin'
$git = Join-Path $gitCmd 'git.exe'
$userRoot = Join-Path $WorkRoot 'installer-user'
$installerHome = Join-Path $userRoot 'installer'
$binDir = Join-Path $installerHome 'bin'
$managed = Join-Path $binDir 'festival.exe'
$bootstrap = Join-Path $WorkRoot 'bootstrap\festival.exe'
$repo = Join-Path $WorkRoot 'local-marketplace'
$packagePath = Join-Path $repo 'packages\obedience-corp\festival\obey-package.json'
$workspace = Join-Path $WorkRoot 'user-workspace'
$sentinel = Join-Path $workspace 'keep-this-camp.txt'
$expectedCandidate = Join-Path $WorkRoot 'candidate-hashes.json'
$fixtureVersion = '0.0.1'
$port = 18087
$script:commandNumber = 0

$env:PATH = "$binDir;$gitCmd;$gitMingw;$gitUsr;$PSHOME;C:\Windows\System32;C:\Windows"
$env:HOME = $userRoot
$env:USERPROFILE = $userRoot
$env:FESTIVAL_HOME = $installerHome
$env:TEMP = Join-Path $userRoot 'tmp'
$env:TMP = $env:TEMP
$env:CAMP_NO_DEFER = '1'
$env:NO_COLOR = '1'
$env:GIT_AUTHOR_NAME = 'Windows Installer Proof'
$env:GIT_AUTHOR_EMAIL = 'windows-installer-proof@example.invalid'
$env:GIT_COMMITTER_NAME = $env:GIT_AUTHOR_NAME
$env:GIT_COMMITTER_EMAIL = $env:GIT_AUTHOR_EMAIL
Remove-Item Env:CAMP_ROOT -ErrorAction SilentlyContinue
Remove-Item Env:OBEY_INSTALLER_HOME -ErrorAction SilentlyContinue

function Assert-File([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "missing file: $Path" }
}

function Invoke-CommandFile {
    param([string]$Executable, [string[]]$CommandArgs, [switch]$ExpectFailure)
    $script:commandNumber++
    $stdoutPath = Join-Path $WorkRoot ("command-$($script:commandNumber)-stdout.txt")
    $stderrPath = Join-Path $WorkRoot ("command-$($script:commandNumber)-stderr.txt")
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & $Executable @CommandArgs 1> $stdoutPath 2> $stderrPath
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }
    $stdout = Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue
    $stderr = Get-Content -LiteralPath $stderrPath -Raw -ErrorAction SilentlyContinue
    Write-Host "installer command: $([IO.Path]::GetFileName($Executable)) $($CommandArgs -join ' ') => $code"
    if ($stderr) { Write-Host "stderr: $stderr" }
    if ($ExpectFailure) {
        if ($code -eq 0) { throw "command unexpectedly succeeded: $($CommandArgs -join ' ')`n$stdout" }
    } elseif ($code -ne 0) {
        throw "command failed ($code): $($CommandArgs -join ' ')`n$stdout`n$stderr"
    }
    return [pscustomobject]@{ Code = [int]$code; Output = [string]$stdout; Error = [string]$stderr }
}

function Invoke-JsonCli {
    param([string]$Executable, [string[]]$CommandArgs)
    $result = Invoke-CommandFile -Executable $Executable -CommandArgs $CommandArgs
    $doc = $result.Output | ConvertFrom-Json
    if (-not $doc.ok) { throw "CLI JSON response was not successful: $($result.Output)" }
    return $doc.data
}

function Assert-Workspace {
    Assert-File $sentinel
    if ([IO.File]::ReadAllText($sentinel) -ne 'user workspace survives installer lifecycle') {
        throw 'installer changed user workspace data'
    }
}

function Get-ArchiveVersion {
    $name = $script:archiveName
    if ($name -notmatch '^festival-(\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?)-windows-x86_64\.zip$') {
        throw "candidate archive filename does not carry a suite version: $name"
    }
    return $Matches[1]
}

function Assert-CandidateChecksum {
    Assert-File $archive
    Assert-File $checksums
    $digest = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
    $lines = @(Get-Content -LiteralPath $checksums | Where-Object {
        $_ -match '^[0-9a-fA-F]{64}\s+\*?festival-.+-windows-x86_64\.zip$'
    })
    if ($lines.Count -ne 1 -or $lines[0] -notmatch '^([0-9a-fA-F]{64})\s+\*?(festival-.+-windows-x86_64\.zip)$') {
        throw 'checksums.txt must contain exactly one Windows suite ZIP entry'
    }
    $script:archiveName = $Matches[2]
    if ($Matches[1].ToLowerInvariant() -ne $digest) {
        throw "candidate ZIP hash does not match checksums.txt entry for $script:archiveName"
    }
    return $digest
}

function Write-PackageManifest([string]$Version, [string]$Url, [string]$Sha256) {
    $entries = @(
        @{ kind = 'binary'; source = 'camp'; executable_name = 'camp' },
        @{ kind = 'binary'; source = 'fest'; executable_name = 'fest' },
        @{ kind = 'binary'; source = 'festival'; executable_name = 'festival' }
    )
    $release = @{
        version = $Version
        channel = 'stable'
        published_at = '2026-10-14T00:00:00Z'
        components = @{ camp = $Version; fest = $Version; festival = $Version }
        compatibility = @{ os = @('windows'); arch = @('amd64') }
        dependencies = @()
        artifacts = @(@{
            kind = 'suite-archive'; os = 'windows'; arch = 'amd64'; url = $Url
            sha256 = $Sha256; filename = [IO.Path]::GetFileName(([uri]$Url).AbsolutePath)
            binaries = @('camp', 'fest', 'festival')
        })
        install = @{ entries = $entries }
    }
    $manifest = @{
        schema_version = 1; id = 'obedience-corp/festival'; class = 'product'
        display_name = 'Festival'; summary = 'Windows candidate installer proof'
        provides_binaries = @('camp', 'fest', 'festival')
        releases = @($release)
    }
    [IO.File]::WriteAllText($packagePath, ($manifest | ConvertTo-Json -Depth 16),
        (New-Object Text.UTF8Encoding($false)))
}

function Commit-Manifest([string]$Message) {
    Invoke-CommandFile -Executable $git -CommandArgs @('-C', $repo, 'add', '.') | Out-Null
    Invoke-CommandFile -Executable $git -CommandArgs @('-C', $repo, 'commit', '-m', $Message) | Out-Null
}

function Assert-Installed([string]$Version, [hashtable]$ExpectedHashes) {
    $inventory = Invoke-JsonCli -Executable $managed -CommandArgs @('list', '--json')
    $packages = @($inventory.packages)
    if ($packages.Count -ne 1 -or $packages[0].package_id -ne 'obedience-corp/festival' -or
        $packages[0].version -ne $Version -or @($packages[0].files).Count -ne 3) {
        throw "receipt readback wrong for $Version`: $($inventory | ConvertTo-Json -Depth 8)"
    }
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        $path = Join-Path $binDir $name
        Assert-File $path
        $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $ExpectedHashes[$name]) { throw "$name hash mismatch at $Version" }
        Invoke-CommandFile -Executable $path -CommandArgs @('version') | Out-Null
    }
    $doctor = Invoke-JsonCli -Executable $managed -CommandArgs @('doctor', '--json')
    $checks = @{}
    foreach ($check in @($doctor.checks)) { $checks[[string]$check.id] = [string]$check.status }
    if ($checks['managed_bin_on_path'] -ne 'ok' -or $checks['receipts_integrity'] -ne 'ok' -or
        $checks['sources_reachable'] -ne 'ok' -or $checks['marketplace_trust'] -ne 'warn') {
        throw "doctor checks wrong at $Version`: $($checks | ConvertTo-Json)"
    }
    Assert-Workspace
    Write-Host "installed $Version`: three executable hashes, receipt, doctor, workspace: PASS"
}

function New-PriorFixtureZip {
    param([string]$Extracted)
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $prior = Join-Path $WorkRoot 'prior-binaries'
    [void][IO.Directory]::CreateDirectory($prior)
    $hashes = @{}
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        $from = Join-Path $Extracted $name
        Assert-File $from
        $to = Join-Path $prior $name
        [IO.File]::Copy($from, $to, $true)
        $bytes = [Text.Encoding]::ASCII.GetBytes("`ninstaller-prior-fixture-$name`n")
        $stream = [IO.File]::Open($to, [IO.FileMode]::Append, [IO.FileAccess]::Write)
        try { $stream.Write($bytes, 0, $bytes.Length) } finally { $stream.Dispose() }
        $hashes[$name] = (Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash.ToLowerInvariant()
        Invoke-CommandFile -Executable $to -CommandArgs @('version') | Out-Null
    }
    $priorZip = Join-Path $WorkRoot 'prior.zip'
    [IO.Compression.ZipFile]::CreateFromDirectory($prior, $priorZip)
    return [pscustomobject]@{ Zip = $priorZip; Directory = $prior; Hashes = $hashes;
        Digest = (Get-FileHash -LiteralPath $priorZip -Algorithm SHA256).Hash.ToLowerInvariant() }
}

function Start-ArchiveServer([string]$PriorZip) {
    $job = Start-Job -ArgumentList $PriorZip, $archive, $port -ScriptBlock {
        param([string]$oldZip, [string]$newZip, [int]$listenPort)
        $listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, $listenPort)
        $listener.Start()
        try {
            while ($true) {
                $client = $listener.AcceptTcpClient()
                try {
                    $stream = $client.GetStream()
                    $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::ASCII, $false, 1024, $true)
                    $request = $reader.ReadLine()
                    while ($null -ne ($line = $reader.ReadLine()) -and $line.Length -gt 0) { }
                    $path = if ($request -match '^(GET|HEAD) /prior\.zip HTTP/') { $oldZip }
                        elseif ($request -match '^(GET|HEAD) /candidate\.zip HTTP/') { $newZip }
                        else { $null }
                    if (-not $path) {
                        $reply = [Text.Encoding]::ASCII.GetBytes("HTTP/1.1 404 Not Found`r`nContent-Length: 0`r`nConnection: close`r`n`r`n")
                        $stream.Write($reply, 0, $reply.Length)
                        continue
                    }
                    $length = (Get-Item -LiteralPath $path).Length
                    $header = [Text.Encoding]::ASCII.GetBytes("HTTP/1.1 200 OK`r`nContent-Type: application/zip`r`nContent-Length: $length`r`nConnection: close`r`n`r`n")
                    $stream.Write($header, 0, $header.Length)
                    if ($request.StartsWith('GET ')) {
                        $file = [IO.File]::OpenRead($path)
                        try { $file.CopyTo($stream) } finally { $file.Dispose() }
                    }
                } finally { $client.Dispose() }
            }
        } finally { $listener.Stop() }
    }
    for ($attempt = 0; $attempt -lt 40; $attempt++) {
        if ($job.State -eq 'Failed') { throw "archive server failed: $(Receive-Job $job | Out-String)" }
        try {
            $probe = [Net.Sockets.TcpClient]::new('127.0.0.1', $port)
            try {
                $payload = [Text.Encoding]::ASCII.GetBytes("HEAD /candidate.zip HTTP/1.1`r`nHost: localhost`r`n`r`n")
                $stream = $probe.GetStream()
                $stream.Write($payload, 0, $payload.Length)
                $reply = [IO.StreamReader]::new($stream, [Text.Encoding]::ASCII)
                if ($reply.ReadLine() -match '^HTTP/1\.1 200') { return $job }
            } finally { $probe.Dispose() }
        } catch { Start-Sleep -Milliseconds 250 }
    }
    throw 'archive server did not start'
}

function Assert-ListVersion([string]$Version) {
    $inventory = Invoke-JsonCli -Executable $managed -CommandArgs @('list', '--json')
    if (@($inventory.packages).Count -ne 1 -or $inventory.packages[0].version -ne $Version) {
        throw "receipt version changed unexpectedly: $($inventory | ConvertTo-Json -Depth 6)"
    }
}

function Invoke-Run {
    foreach ($required in @($archive, $checksums, $git)) { Assert-File $required }
    [void][IO.Directory]::CreateDirectory($env:TEMP)
    [void][IO.Directory]::CreateDirectory($workspace)
    [IO.File]::WriteAllText($sentinel, 'user workspace survives installer lifecycle')
    $candidateDigest = Assert-CandidateChecksum
    $candidateVersion = Get-ArchiveVersion
    $expanded = Join-Path $WorkRoot 'candidate-expanded'
    Expand-Archive -LiteralPath $archive -DestinationPath $expanded
    $candidateHashes = @{}
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        $candidateHashes[$name] = (Get-FileHash -LiteralPath (Join-Path $expanded $name) -Algorithm SHA256).Hash.ToLowerInvariant()
    }
    [IO.File]::WriteAllText($expectedCandidate, ($candidateHashes | ConvertTo-Json),
        (New-Object Text.UTF8Encoding($false)))
    $prior = New-PriorFixtureZip -Extracted $expanded
    if ($prior.Digest -eq $candidateDigest) { throw 'prior fixture is identical to candidate ZIP' }
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        if ($prior.Hashes[$name] -eq $candidateHashes[$name]) { throw "$name prior fixture did not differ" }
    }

    $server = Start-ArchiveServer -PriorZip $prior.Zip
    try {
        [void][IO.Directory]::CreateDirectory((Split-Path -Parent $packagePath))
        [IO.File]::WriteAllText((Join-Path $repo 'obey-marketplace.json'),
            '{"id":"fixture/installer-proof","name":"Installer proof","schema_version":"1","packages":[{"id":"obedience-corp/festival","display_name":"Festival","class":"product","manifest_path":"packages/obedience-corp/festival/obey-package.json"}]}',
            (New-Object Text.UTF8Encoding($false)))
        Write-PackageManifest $fixtureVersion "http://127.0.0.1:$port/prior.zip" $prior.Digest
        Invoke-CommandFile -Executable $git -CommandArgs @('-C', $repo, 'init', '-b', 'main') | Out-Null
        Commit-Manifest 'prior Windows suite fixture'

        [void][IO.Directory]::CreateDirectory($binDir)
        [void][IO.Directory]::CreateDirectory((Split-Path -Parent $bootstrap))
        [IO.File]::Copy((Join-Path $expanded 'festival.exe'), $bootstrap, $true)
        [IO.File]::Copy((Join-Path $prior.Directory 'festival.exe'), $managed, $true)
        [IO.File]::WriteAllText((Join-Path $installerHome 'config.toml'), "[marketplaces]`ndefault = 'candidate-fixture'`n")

        Invoke-CommandFile -Executable $bootstrap -CommandArgs @('marketplace', 'add', $repo,
            '--name', 'candidate-fixture', '--allow-unverified') | Out-Null
        $installed = Invoke-JsonCli -Executable $managed -CommandArgs @('install', 'festival',
            '--allow-unverified', '--json')
        if ($installed.self_placement -ne 'managed' -or $installed.self_skipped -or
            @($installed.files).Count -ne 3) { throw "initial install did not replace managed suite: $($installed | ConvertTo-Json)" }
        Assert-Installed $fixtureVersion $prior.Hashes

        Write-PackageManifest $candidateVersion "http://127.0.0.1:$port/candidate.zip" $candidateDigest
        Commit-Manifest 'candidate Windows suite fixture'
        $updated = Invoke-JsonCli -Executable $managed -CommandArgs @('update', 'festival',
            '--allow-unverified', '--json')
        if ($updated.action -ne 'upgraded' -or $updated.from -ne $fixtureVersion -or
            $updated.version -ne $candidateVersion -or -not $updated.self_replaced) {
            throw "managed suite update did not replace self: $($updated | ConvertTo-Json)"
        }
        Assert-Installed $candidateVersion $candidateHashes

        # Model a process killed after moving camp to its durable pre-image
        # backup and placing a partial new image. The next install must
        # reconcile this intent before checksum verification; a deliberately
        # bad checksum then proves recovery is independent of a new install.
        $journalId = [Guid]::NewGuid().ToString('N')
        $backupDir = Join-Path $installerHome "intent-backups\$journalId"
        [void][IO.Directory]::CreateDirectory($backupDir)
        $camp = Join-Path $binDir 'camp.exe'
        $campBackup = Join-Path $backupDir 'camp.exe'
        [IO.File]::Move($camp, $campBackup)
        [IO.File]::Copy((Join-Path $prior.Directory 'camp.exe'), $camp)
        $journal = @{
            id = $journalId; package_id = 'obedience-corp/festival'
            version = $fixtureVersion; channel = 'stable'; source = 'candidate-fixture'
            started_at = (Get-Date).ToUniversalTime().ToString('o')
            placed = @(@{ dest = $camp; backup = $campBackup })
        }
        [IO.File]::WriteAllText((Join-Path $installerHome 'install-intent.json'),
            ($journal | ConvertTo-Json -Depth 8), (New-Object Text.UTF8Encoding($false)))
        Write-PackageManifest $candidateVersion "http://127.0.0.1:$port/candidate.zip" ('0' * 64)
        Commit-Manifest 'invalid checksum after interrupted activation'
        $failure = Invoke-CommandFile -Executable $managed -CommandArgs @('install', 'festival',
            '--allow-unverified', '--json') -ExpectFailure
        if (($failure.Output + $failure.Error) -notmatch 'SHA|checksum|hash') {
            throw "failed install did not identify checksum failure: $($failure.Output) $($failure.Error)"
        }
        if (Test-Path -LiteralPath (Join-Path $installerHome 'install-intent.json')) {
            throw 'recovery left interrupted transaction journal'
        }
        if ((Get-FileHash -LiteralPath $camp -Algorithm SHA256).Hash.ToLowerInvariant() -ne $candidateHashes['camp.exe']) {
            throw 'interrupted transaction did not restore prior working camp.exe'
        }
        Assert-ListVersion $candidateVersion
        Write-Host 'interrupted transaction recovered before rejected checksum: PASS'

        Write-PackageManifest $candidateVersion "http://127.0.0.1:$port/candidate.zip" $candidateDigest
        Commit-Manifest 'restore candidate checksum for reinstall'
        $reinstalled = Invoke-JsonCli -Executable $managed -CommandArgs @('install', 'festival',
            '--allow-unverified', '--json')
        if ($reinstalled.version -ne $candidateVersion -or @($reinstalled.files).Count -ne 3 -or
            $reinstalled.self_skipped) { throw "reinstall incomplete: $($reinstalled | ConvertTo-Json)" }
        Assert-Installed $candidateVersion $candidateHashes

        $removed = Invoke-JsonCli -Executable $bootstrap -CommandArgs @('uninstall', 'festival', '--json')
        if (@($removed.removed).Count -ne 3) { throw "external-hub uninstall did not remove three owned binaries: $($removed | ConvertTo-Json)" }
        foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
            if (Test-Path -LiteralPath (Join-Path $binDir $name)) { throw "uninstall left managed $name" }
        }
        Assert-Workspace
        Write-Host 'Windows installer CLI candidate journey: PASS'
    } finally {
        Stop-Job -Job $server -ErrorAction SilentlyContinue | Out-Null
        Remove-Job -Job $server -Force -ErrorAction SilentlyContinue | Out-Null
    }
}

function Invoke-Readback {
    Assert-File $bootstrap
    Assert-File $expectedCandidate
    Assert-Workspace
    $inventory = Invoke-JsonCli -Executable $bootstrap -CommandArgs @('list', '--json')
    if (@($inventory.packages).Count -ne 0) {
        throw "fresh-process readback found an installed receipt: $($inventory | ConvertTo-Json)"
    }
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        if (Test-Path -LiteralPath (Join-Path $binDir $name)) { throw "fresh-process readback found $name" }
    }
    $hashes = Get-Content -LiteralPath $expectedCandidate -Raw | ConvertFrom-Json
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        if ([string]::IsNullOrWhiteSpace($hashes.PSObject.Properties[$name].Value)) {
            throw "missing candidate hash for $name"
        }
    }
    Write-Host 'Windows installer CLI fresh-process readback: PASS'
}

if ($Mode -eq 'run') { Invoke-Run } else { Invoke-Readback }
