#Requires -Version 5.1
param([Parameter(Mandatory = $true)][string]$WorkRoot)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$archive = Join-Path $WorkRoot 'suite.zip'
$manifestPath = Join-Path $WorkRoot 'festival.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$actualHash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
if ($manifest.architecture.'64bit'.hash -ne $actualHash) {
    throw 'Scoop candidate hash changed after entering the container'
}

$workspace = Join-Path $WorkRoot 'workspace'
[System.IO.Directory]::CreateDirectory($workspace) | Out-Null
$sentinel = Join-Path $workspace 'keep-this-camp.txt'
[System.IO.File]::WriteAllText($sentinel, 'user workspace survives Scoop lifecycle')
$env:CAMP_ROOT = $workspace

function Assert-Workspace {
    if (-not (Test-Path -LiteralPath $sentinel -PathType Leaf) -or
        [System.IO.File]::ReadAllText($sentinel) -ne 'user workspace survives Scoop lifecycle') {
        throw 'Scoop lifecycle changed the user workspace'
    }
}

# Scoop downloads from HTTP(S). Serve the exact candidate ZIP on loopback, so
# the snapshot manifest can be installed before a GitHub release exists.
$port = 18086
$server = Start-Job -ArgumentList $archive, $port -ScriptBlock {
    param([string]$zipPath, [int]$listenPort)
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
                if ($request -notmatch '^(GET|HEAD) /suite-(install|update)\.zip HTTP/') {
                    $reply = [Text.Encoding]::ASCII.GetBytes("HTTP/1.1 404 Not Found`r`nContent-Length: 0`r`nConnection: close`r`n`r`n")
                    $stream.Write($reply, 0, $reply.Length)
                    continue
                }
                $length = (Get-Item -LiteralPath $zipPath).Length
                $header = [Text.Encoding]::ASCII.GetBytes("HTTP/1.1 200 OK`r`nContent-Type: application/zip`r`nContent-Length: $length`r`nConnection: close`r`n`r`n")
                $stream.Write($header, 0, $header.Length)
                if ($request.StartsWith('GET ')) {
                    $file = [System.IO.File]::OpenRead($zipPath)
                    try { $file.CopyTo($stream) } finally { $file.Dispose() }
                }
            } finally {
                $client.Dispose()
            }
        }
    } finally {
        $listener.Stop()
    }
}

try {
    $ready = $false
    for ($attempt = 0; $attempt -lt 40; $attempt++) {
        if ($server.State -eq 'Failed') {
            throw "Local ZIP server failed: $(Receive-Job -Job $server | Out-String)"
        }
        try {
            $probe = New-Object Net.Sockets.TcpClient
            $probe.Connect('127.0.0.1', $port)
            $bytes = [Text.Encoding]::ASCII.GetBytes("HEAD /suite-install.zip HTTP/1.1`r`nHost: localhost`r`n`r`n")
            $probeStream = $probe.GetStream()
            $probeStream.Write($bytes, 0, $bytes.Length)
            $probeReader = [IO.StreamReader]::new($probeStream, [Text.Encoding]::ASCII)
            if ($probeReader.ReadLine() -notmatch '^HTTP/1\.1 200') {
                throw 'Local ZIP server returned an unexpected probe response'
            }
            $probe.Dispose()
            $ready = $true
            break
        } catch {
            Start-Sleep -Milliseconds 250
        }
    }
    if (-not $ready) { throw 'Local ZIP server did not start' }

    $manifest.architecture.'64bit'.url = "http://127.0.0.1:$port/suite-install.zip"
    $manifest | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    $scoopRoot = Join-Path $WorkRoot 'scoop'
    $env:SCOOP = $scoopRoot
    $env:PATH = "$(Join-Path $scoopRoot 'shims');$env:PATH"
    $bootstrap = Join-Path $WorkRoot 'scoop-install.ps1'
    Invoke-WebRequest -Uri 'https://get.scoop.sh' -UseBasicParsing -OutFile $bootstrap
    $ps51 = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    & $ps51 -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $bootstrap -ScoopDir $scoopRoot
    if ($LASTEXITCODE -ne 0) { throw "Scoop bootstrap failed ($LASTEXITCODE)" }
    $scoop = Join-Path $scoopRoot 'apps\scoop\current\bin\scoop.ps1'
    if (-not (Test-Path -LiteralPath $scoop -PathType Leaf)) { throw 'Scoop CLI missing after bootstrap' }

    function Invoke-Scoop([string[]]$Arguments) {
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

    Invoke-Scoop -Arguments @('install', $manifestPath)
    Assert-Shims
    Assert-Workspace
    Write-Host "Scoop installed candidate version $($manifest.version)"

    if ($manifest.version -notmatch '^(\d+)\.(\d+)\.(\d+)') {
        throw "Cannot derive fixture update version from $($manifest.version)"
    }
    $nextVersion = '{0}.{1}.{2}' -f $Matches[1], $Matches[2], ([int]$Matches[3] + 1)
    $manifest.version = $nextVersion
    $manifest.architecture.'64bit'.url = "http://127.0.0.1:$port/suite-update.zip"
    $manifest | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
    Invoke-Scoop -Arguments @('update', 'festival')
    $updated = Join-Path $scoopRoot "apps\festival\$nextVersion"
    if (-not (Test-Path -LiteralPath $updated -PathType Container)) {
        throw "Scoop update did not install $nextVersion"
    }
    Assert-Shims
    Assert-Workspace
    Write-Host "Scoop updated candidate fixture to $nextVersion"

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
    Write-Host 'Windows Scoop container proof: PASS'
} finally {
    Stop-Job -Job $server -ErrorAction SilentlyContinue | Out-Null
    Remove-Job -Job $server -Force -ErrorAction SilentlyContinue | Out-Null
}
