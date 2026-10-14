#Requires -Version 5.1
<#
Run the exact release ZIP's camp.exe and fest.exe as ContainerUser. The create
and readback modes run in separate PowerShell 5.1 processes in one disposable
Windows Server Core container. Keep this source ASCII for the inbox interpreter.
#>
param(
    [Parameter(Mandatory = $true)][string]$WorkRoot,
    [Parameter(Mandatory = $true)][ValidateSet('create', 'readback')][string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$install = Join-Path $WorkRoot 'Install Folder [native]'
$camp = Join-Path $install 'camp.exe'
$fest = Join-Path $install 'fest.exe'
$festivalExe = Join-Path $install 'festival.exe'
$gitCmd = Join-Path $WorkRoot 'Git\cmd'
$gitMingw = Join-Path $WorkRoot 'Git\mingw64\bin'
$git = Join-Path $gitCmd 'git.exe'
foreach ($required in @($camp, $fest, $festivalExe, $git)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        throw "installed journey prerequisite missing: $required"
    }
}

$homeRoot = Join-Path $WorkRoot 'journey-home'
$base = Join-Path $WorkRoot 'journey-workspaces'
$campRoot = Join-Path $base 'native-beginner'
$source = Join-Path $WorkRoot 'native-source-project'
$statePath = Join-Path $WorkRoot 'journey-state.json'
$firstRunHome = Join-Path $WorkRoot 'first-run-home'
$firstRunStatePath = Join-Path $WorkRoot 'first-run-state.json'
$firstRunInstallerHome = Join-Path $firstRunHome 'installer'
$firstRunBin = Join-Path $firstRunInstallerHome 'bin'
$firstRunFestival = Join-Path $firstRunBin 'festival.exe'
$env:PATH = "$install;$gitCmd;$gitMingw;$env:PATH"
$env:HOME = $homeRoot
$env:USERPROFILE = $homeRoot
$env:XDG_CONFIG_HOME = Join-Path $homeRoot 'config'
$env:CAMP_REGISTRY_PATH = Join-Path $homeRoot 'registry.json'
$env:FEST_CONFIG_DIR = Join-Path $homeRoot 'fest-config'
$env:CAMP_NO_DEFER = '1'
$env:NO_COLOR = '1'
$env:GIT_AUTHOR_NAME = 'Windows Suite Proof'
$env:GIT_AUTHOR_EMAIL = 'windows-proof@example.invalid'
$env:GIT_COMMITTER_NAME = $env:GIT_AUTHOR_NAME
$env:GIT_COMMITTER_EMAIL = $env:GIT_AUTHOR_EMAIL
Remove-Item Env:CAMP_ROOT -ErrorAction SilentlyContinue

function Invoke-Native {
    param([string]$Executable, [string[]]$Arguments, [switch]$AllowFailure)
    Write-Host "journey command: $([System.IO.Path]::GetFileName($Executable)) $($Arguments -join ' ')"
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $output = & $Executable @Arguments 2>&1 | Out-String
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }
    if (-not $AllowFailure -and $code -ne 0) {
        throw "$Executable $($Arguments -join ' ') failed ($code): $output"
    }
    return [pscustomobject]@{ Code = [int]$code; Output = [string]$output }
}

function Get-OnlyDirectory {
    param([string]$Parent, [string]$Pattern)
    $items = @(Get-ChildItem -LiteralPath $Parent -Directory -Filter $Pattern)
    if ($items.Count -ne 1) {
        throw "expected one directory matching $Pattern under $Parent, found $($items.Count)"
    }
    return $items[0].FullName
}

function New-MarkersFile {
    param([string]$Label, [string[]]$Arguments)
    $preview = Invoke-Native $fest $Arguments
    $data = $preview.Output | ConvertFrom-Json
    if (-not $data.ok -or -not $data.dry_run) {
        throw "$Label dry-run did not report ok/dry_run: $($preview.Output)"
    }
    $markers = @{}
    $known = @{
        'First phase name' = '001_INGEST'
        'Phase name like 001_INGEST' = '001_INGEST'
        'Phase name like 001_PLANNING' = '002_PLAN'
        'Phase Name' = '001_INGEST'
        'Planning/Active/Review/Complete' = 'Planning'
        'Not Started/In Progress/Completed/Blocked' = 'Not Started'
        'Yes/No' = 'Yes'
        'First phase name and brief description' = '001_INGEST - capture Windows beginner requirements'
        'Sequence names or N/A for planning phases' = 'N/A'
        'List blockers or None' = 'None'
    }
    foreach ($marker in @($data.markers | Where-Object { $null -ne $_ })) {
        if (-not $marker.hint) { throw "$Label preview contains marker without hint" }
        $hint = [string]$marker.hint
        if (-not $markers.ContainsKey($hint)) {
            # A value for each actual template hint is enough to verify the
            # rendered scaffold. The separate result file records the proof.
            $markers[$hint] = if ($known.ContainsKey($hint)) { $known[$hint] } else { "Windows installed suite proof: $hint" }
        }
    }
    $file = Join-Path $WorkRoot ("$Label-markers.json")
    [System.IO.File]::WriteAllText($file, ($markers | ConvertTo-Json -Depth 4),
        (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "$Label preview markers: $($markers.Count)"
    return $file
}

function Assert-File([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "missing persisted file: $Path"
    }
}

function Assert-Doctor([object]$Report, [string]$Stage) {
    $checks = @($Report.data.checks)
    $byId = @{}
    foreach ($check in $checks) {
        if ($byId.ContainsKey([string]$check.id)) {
            throw "$Stage festival doctor repeated check $($check.id)"
        }
        $byId[[string]$check.id] = $check
    }
    foreach ($id in @('managed_bin_on_path', 'sources_reachable',
        'marketplace_trust', 'receipts_integrity', 'path_shadowing')) {
        if (-not $byId.ContainsKey($id)) {
            throw "$Stage festival doctor omitted $id"
        }
    }
    if (-not $Report.ok -or $checks.Count -ne 5 -or
        $byId['managed_bin_on_path'].status -ne 'ok' -or
        $byId['receipts_integrity'].status -ne 'ok' -or
        @($checks | Where-Object { $_.status -eq 'fail' }).Count -ne 0) {
        throw "$Stage festival doctor reports failed or incomplete checks: $($Report | ConvertTo-Json -Compress -Depth 5)"
    }
}

function Use-FirstRunEnvironment([scriptblock]$Body) {
    $names = @('HOME', 'USERPROFILE', 'XDG_CONFIG_HOME', 'CAMP_REGISTRY_PATH',
        'FEST_CONFIG_DIR', 'FESTIVAL_HOME', 'OBEY_INSTALLER_HOME', 'CAMP_ROOT',
        'PATH', 'TEMP', 'TMP')
    $saved = @{}
    foreach ($name in $names) {
        $saved[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
    }
    try {
        $tmp = Join-Path $firstRunHome 'tmp'
        [void][System.IO.Directory]::CreateDirectory($tmp)
        $env:HOME = $firstRunHome
        $env:USERPROFILE = $firstRunHome
        $env:XDG_CONFIG_HOME = Join-Path $firstRunHome 'config'
        $env:CAMP_REGISTRY_PATH = Join-Path $firstRunHome 'registry.json'
        $env:FEST_CONFIG_DIR = Join-Path $firstRunHome 'fest-config'
        $env:FESTIVAL_HOME = $firstRunInstallerHome
        $env:PATH = "$firstRunBin;$gitCmd;$gitMingw;C:\Windows\System32;C:\Windows"
        $env:TEMP = $tmp
        $env:TMP = $tmp
        [Environment]::SetEnvironmentVariable('OBEY_INSTALLER_HOME', $null, 'Process')
        [Environment]::SetEnvironmentVariable('CAMP_ROOT', $null, 'Process')
        & $Body
    } finally {
        foreach ($name in $names) {
            [Environment]::SetEnvironmentVariable($name, $saved[$name], 'Process')
        }
    }
}

function Invoke-FirstRunSetupProof {
    [void][System.IO.Directory]::CreateDirectory($firstRunBin)
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        $from = Join-Path $install $name
        $to = Join-Path $firstRunBin $name
        [System.IO.File]::Copy($from, $to)
        if ((Get-FileHash -LiteralPath $from -Algorithm SHA256).Hash -ne
            (Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash) {
            throw "managed first-run copy differs from extracted candidate ZIP: $name"
        }
    }
    Write-Host 'fresh-user managed bin contains three exact candidate ZIP binaries'
    Use-FirstRunEnvironment {
        $doctorBefore = (Invoke-Native $firstRunFestival @('doctor', '--json')).Output | ConvertFrom-Json
        Assert-Doctor $doctorBefore 'before setup'
        if (Test-Path -LiteralPath $env:CAMP_REGISTRY_PATH) {
            throw 'clean-user festival doctor created a camp registry'
        }
        Write-Host 'clean-user festival doctor before setup: OK'

        # Recreate the durable state left by a process interrupted after Camp
        # journals its staging directory and before it writes the scaffold.
        $base = Join-Path $firstRunHome 'campaigns'
        $target = Join-Path $base 'festival'
        $staging = Join-Path $base '.festival-setup-interrupted\festival'
        [void][System.IO.Directory]::CreateDirectory($staging)
        $sentinel = Join-Path $staging 'keep-user-data.txt'
        [System.IO.File]::WriteAllText($sentinel, 'preserve interrupted setup data')
        $configDir = Join-Path $firstRunHome 'config\obey\campaign'
        [void][System.IO.Directory]::CreateDirectory($configDir)
        $journal = Join-Path $configDir 'starter.json'
        $invalid = @{ version = 1; completed = $false; path = $target;
            staging = (Join-Path $WorkRoot 'outside-starter\festival'); ready = $false }
        [System.IO.File]::WriteAllText($journal, ($invalid | ConvertTo-Json -Depth 3),
            (New-Object System.Text.UTF8Encoding($false)))
        $rejected = Invoke-Native $firstRunFestival @('setup', '--json') -AllowFailure
        if ($rejected.Code -eq 0 -or $rejected.Output -notmatch 'invalid staging path' -or
            (Test-Path -LiteralPath $target) -or
            (Test-Path -LiteralPath $env:CAMP_REGISTRY_PATH)) {
            throw "unsafe interrupted starter journal was not rejected cleanly: $($rejected.Output)"
        }
        Write-Host 'negative foreign staging path: rejected without publishing or registering'

        $interrupted = @{ version = 1; completed = $false; path = $target;
            staging = $staging; ready = $false }
        [System.IO.File]::WriteAllText($journal, ($interrupted | ConvertTo-Json -Depth 3),
            (New-Object System.Text.UTF8Encoding($false)))
        if (Test-Path -LiteralPath $env:CAMP_REGISTRY_PATH) {
            throw 'interrupted starter was registered before setup resumed'
        }
        Write-Host 'injected interrupted starter journal before scaffold publication'

        $setup = (Invoke-Native $firstRunFestival @('setup', '--json')).Output | ConvertFrom-Json
        if (-not $setup.ok -or $setup.data.action -ne 'created' -or
            $setup.data.path -ne $target) {
            throw "festival setup did not resume interrupted starter: $($setup | ConvertTo-Json -Compress)"
        }
        Assert-File (Join-Path $target '.campaign\campaign.yaml')
        Assert-File (Join-Path $target '.git\HEAD')
        Assert-File (Join-Path $target 'keep-user-data.txt')
        if ([System.IO.File]::ReadAllText((Join-Path $target 'keep-user-data.txt')) -ne
            'preserve interrupted setup data') {
            throw 'festival setup changed the interrupted user file'
        }
        $journalData = Get-Content -LiteralPath $journal -Raw | ConvertFrom-Json
        $journalStaging = $journalData.PSObject.Properties['staging']
        if (-not $journalData.completed -or
            ($null -ne $journalStaging -and $journalStaging.Value)) {
            throw 'festival setup left its starter journal incomplete'
        }
        $entries = @((Invoke-Native $camp @('list', '--json')).Output | ConvertFrom-Json)
        if ($entries.Count -ne 1 -or $entries[0].name -ne 'festival' -or
            $entries[0].path -ne $target) {
            throw 'resumed setup did not register exactly one starter camp'
        }
        $head = (Invoke-Native $git @('-C', $target, 'rev-parse', 'HEAD')).Output.Trim()
        $again = (Invoke-Native $firstRunFestival @('setup', '--json')).Output | ConvertFrom-Json
        if (-not $again.ok -or $again.data.action -ne 'complete') {
            throw 'second festival setup did not report completed idempotent state'
        }
        $doctorAfter = (Invoke-Native $firstRunFestival @('doctor', '--json')).Output | ConvertFrom-Json
        Assert-Doctor $doctorAfter 'after setup'
        $proof = @{ home = $firstRunHome; camp = $target; journal = $journal;
            sentinel = Join-Path $target 'keep-user-data.txt'; head = $head }
        [System.IO.File]::WriteAllText($firstRunStatePath, ($proof | ConvertTo-Json -Depth 3),
            (New-Object System.Text.UTF8Encoding($false)))
        Write-Host 'Windows installed festival doctor/setup interrupted-resume: PASS'
    }
}

function Assert-FirstRunSetupReadback {
    Assert-File $firstRunStatePath
    $proof = Get-Content -LiteralPath $firstRunStatePath -Raw | ConvertFrom-Json
    foreach ($name in @('camp.exe', 'fest.exe', 'festival.exe')) {
        $from = Join-Path $install $name
        $to = Join-Path $firstRunBin $name
        Assert-File $to
        if ((Get-FileHash -LiteralPath $from -Algorithm SHA256).Hash -ne
            (Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash) {
            throw "fresh-process managed binary differs from extracted candidate ZIP: $name"
        }
    }
    Use-FirstRunEnvironment {
        foreach ($path in @($proof.camp, $proof.journal, $proof.sentinel)) {
            Assert-File $path
        }
        if ([System.IO.File]::ReadAllText($proof.sentinel) -ne 'preserve interrupted setup data') {
            throw 'fresh-process interrupted user file changed'
        }
        $journalData = Get-Content -LiteralPath $proof.journal -Raw | ConvertFrom-Json
        $journalStaging = $journalData.PSObject.Properties['staging']
        if (-not $journalData.completed -or
            ($null -ne $journalStaging -and $journalStaging.Value)) {
            throw 'fresh-process starter journal is incomplete'
        }
        $entries = @((Invoke-Native $camp @('list', '--json')).Output | ConvertFrom-Json)
        if ($entries.Count -ne 1 -or $entries[0].name -ne 'festival' -or
            $entries[0].path -ne $proof.camp) {
            throw 'fresh-process starter registry differs from saved setup'
        }
        $head = (Invoke-Native $git @('-C', $proof.camp, 'rev-parse', 'HEAD')).Output.Trim()
        if ($head -ne $proof.head) { throw 'fresh-process starter Git HEAD changed' }
        $doctor = (Invoke-Native $firstRunFestival @('doctor', '--json')).Output | ConvertFrom-Json
        Assert-Doctor $doctor 'fresh-process readback'
        Write-Host "fresh-process starter registry, Git HEAD, journal, user file, doctor: $head"
        Write-Host 'Windows installed festival doctor/setup readback: PASS'
    }
}

if ($Mode -eq 'create') {
    [void][System.IO.Directory]::CreateDirectory($homeRoot)
    [void][System.IO.Directory]::CreateDirectory($base)
    [void][System.IO.Directory]::CreateDirectory((Join-Path $homeRoot 'tmp'))
    $env:TEMP = Join-Path $homeRoot 'tmp'
    $env:TMP = $env:TEMP

    # A missing Git executable must be reported as a failed setup, rather
    # than leaving a successful-looking camp or registry entry behind.
    $savedPath = $env:PATH
    try {
        $env:PATH = "$install;C:\Windows\System32;C:\Windows"
        $missing = Invoke-Native $camp @('create', 'git-is-missing', '--path', $base,
            '--description', 'Missing Git negative proof',
            '--mission', 'Reject creation when Git is unavailable') -AllowFailure
    } finally {
        $env:PATH = $savedPath
    }
    if ($missing.Code -eq 0 -or $missing.Output -notmatch '(?i)git') {
        throw "missing Git did not fail with a Git diagnostic: $($missing.Output)"
    }
    if (Test-Path -LiteralPath (Join-Path $base 'git-is-missing\.git\HEAD')) {
        throw 'missing-Git attempt created a Git repository'
    }
    if ((Test-Path -LiteralPath $env:CAMP_REGISTRY_PATH) -and
        ((Get-Content -LiteralPath $env:CAMP_REGISTRY_PATH -Raw) -match 'git-is-missing')) {
        throw 'missing-Git attempt was registered as a camp'
    }
    Write-Host 'negative missing-Git creation: rejected'

    $created = Invoke-Native $camp @('create', 'native-beginner', '--path', $base,
        '--description', 'Windows installed suite proof',
        '--mission', 'Reach the first festival task from a clean Windows account')
    Assert-File (Join-Path $campRoot '.campaign\campaign.yaml')
    Assert-File (Join-Path $campRoot '.git\HEAD')
    $firstHead = (Invoke-Native $git @('-C', $campRoot, 'rev-parse', 'HEAD')).Output.Trim()
    if (-not $firstHead) { throw 'camp create did not record its initial Git commit' }
    Write-Host "camp create: $firstHead"

    $occupied = Invoke-Native $camp @('create', 'native-beginner', '--path', $base,
        '--description', 'Occupied target negative proof',
        '--mission', 'Preserve the existing camp when the target is occupied') -AllowFailure
    $afterOccupied = (Invoke-Native $git @('-C', $campRoot, 'rev-parse', 'HEAD')).Output.Trim()
    if ($occupied.Code -eq 0 -or $afterOccupied -ne $firstHead -or
        $occupied.Output -notmatch '(?i)already contains a camp|not empty') {
        throw "occupied camp target was not preserved: $($occupied.Output)"
    }
    Write-Host 'negative occupied-target creation: rejected without changing HEAD'

    [void][System.IO.Directory]::CreateDirectory($source)
    Invoke-Native $git @('-C', $source, 'init') | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $source 'README.md'), "# Native source`n",
        (New-Object System.Text.UTF8Encoding($false)))
    Invoke-Native $git @('-C', $source, 'add', 'README.md') | Out-Null
    Invoke-Native $git @('-C', $source, 'commit', '-m', 'Initialize native source') | Out-Null
    Set-Location -LiteralPath $campRoot
    Invoke-Native $camp @('project', 'link', $source, '--name', 'sample', '--yes') | Out-Null
    Assert-File (Join-Path $source '.camp')
    $projectLink = Join-Path $campRoot 'projects\sample'
    Assert-File (Join-Path $projectLink 'README.md')
    $projects = (Invoke-Native $camp @('project', 'list', '--json')).Output
    if ($projects -notmatch 'sample') { throw "linked project absent from camp list: $projects" }
    Write-Host 'camp project link and list: OK'

    $env:CAMP_ROOT = $campRoot
    $festivalMarkers = New-MarkersFile 'festival' @('create', 'festival', '--name',
        'windows-beginner', '--type', 'standard', '--dry-run', '--json')
    Invoke-Native $fest @('create', 'festival', '--name', 'windows-beginner',
        '--type', 'standard', '--markers-file', $festivalMarkers, '--json') | Out-Null
    $festival = Get-OnlyDirectory (Join-Path $campRoot 'festivals\planning') 'windows-beginner-*'
    Set-Location -LiteralPath $festival
    Invoke-Native $fest @('validate') | Out-Null
    $next = (Invoke-Native $fest @('next', '--no-context')).Output
    if ($next -notmatch '001_INGEST') { throw "first fest next did not reach ingest: $next" }
    $initialProgress = (Invoke-Native $fest @('progress', '--json')).Output | ConvertFrom-Json
    if ($null -eq $initialProgress) { throw 'fest progress returned no JSON' }
    Write-Host 'fest create / validate / next / progress: OK'

    # The standard beginner scaffold enters INGEST. Add a planning task to
    # exercise persisted task progress while this festival is still planning.
    $phase = Get-OnlyDirectory $festival '002_PLAN*'
    $sequenceMarkers = New-MarkersFile 'sequence' @('create', 'sequence', '--name',
        'native journey', '--path', $phase, '--dry-run', '--json')
    Invoke-Native $fest @('create', 'sequence', '--name', 'native journey',
        '--path', $phase, '--markers-file', $sequenceMarkers, '--no-prompt',
        '--json') | Out-Null
    $sequence = Get-OnlyDirectory $phase '01_native_journey*'
    $taskMarkers = New-MarkersFile 'task' @('create', 'task', '--name',
        'verify installed tools', '--path', $sequence, '--dry-run', '--json')
    Invoke-Native $fest @('create', 'task', '--name', 'verify installed tools',
        '--path', $sequence, '--markers-file', $taskMarkers, '--json') | Out-Null
    $task = Join-Path $sequence '01_verify_installed_tools.md'
    Assert-File $task
    $results = Join-Path $sequence 'results'
    [void][System.IO.Directory]::CreateDirectory($results)
    [System.IO.File]::WriteAllText((Join-Path $results '01_verify_installed_tools.md'),
        "Installed ZIP launch, camp create, linked project, fest next, and progress passed as ContainerUser.`n",
        (New-Object System.Text.UTF8Encoding($false)))
    # A bare filename is unambiguous in this fixture and is portable across
    # Fest's slash-normalized task IDs and Windows native paths.
    $complete = Invoke-Native $fest @('task', 'completed', '01_verify_installed_tools.md', '--yes', '--json')
    $completedJson = $complete.Output | ConvertFrom-Json
    if (-not $completedJson.success) { throw "task completion did not report success: $($complete.Output)" }
    $completedProgress = (Invoke-Native $fest @('progress', '--task',
        '01_verify_installed_tools.md', '--json')).Output | ConvertFrom-Json
    if ($completedProgress.status -ne 'completed') {
        throw "completed task absent from progress: $($completedProgress | ConvertTo-Json -Compress)"
    }
    Invoke-Native $fest @('commit', '-m', 'Verify installed Windows beginner journey') | Out-Null
    $savedHead = (Invoke-Native $git @('-C', $campRoot, 'rev-parse', 'HEAD')).Output.Trim()
    if ($savedHead -eq $firstHead) { throw 'fest commit did not update camp Git history' }
    $state = @{
        camp = $campRoot
        source = $source
        festival = $festival
        task = $task
        committed_head = $savedHead
    }
    [System.IO.File]::WriteAllText($statePath, ($state | ConvertTo-Json -Depth 3),
        (New-Object System.Text.UTF8Encoding($false)))
    Invoke-FirstRunSetupProof
    Write-Host 'Windows installed beginner journey create: PASS'
    exit 0
}

Assert-File $statePath
$saved = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
foreach ($path in @($saved.camp, $saved.source, $saved.festival, $saved.task)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "journey readback missing: $path" }
}
Assert-File (Join-Path $saved.source '.camp')
Assert-File (Join-Path $saved.camp 'projects\sample\README.md')
$readHead = (Invoke-Native $git @('-C', $saved.camp, 'rev-parse', 'HEAD')).Output.Trim()
if ($readHead -ne $saved.committed_head) {
    throw "fresh-process camp HEAD $readHead differs from saved $($saved.committed_head)"
}
$env:CAMP_ROOT = $saved.camp
Set-Location -LiteralPath $saved.festival
$nextReadback = (Invoke-Native $fest @('next', '--no-context')).Output
if ($nextReadback -notmatch '001_INGEST') {
    throw "fresh-process fest next lost ingest context: $nextReadback"
}
$progressReadback = (Invoke-Native $fest @('progress', '--task',
    '01_verify_installed_tools.md', '--json')).Output | ConvertFrom-Json
if ($progressReadback.status -ne 'completed') {
    throw "fresh-process task progress lost completion: $($progressReadback | ConvertTo-Json -Compress)"
}
Assert-File (Join-Path $saved.festival '.fest\progress_events.jsonl')
$activityPath = Join-Path $saved.festival '.fest\activity.jsonl'
Assert-File $activityPath
$activity = @(Get-Content -LiteralPath $activityPath | Where-Object { $_.Trim() } |
    ForEach-Object { $_ | ConvertFrom-Json })
$completedEvents = @($activity | Where-Object {
    $_.event -eq 'task.completed' -and $_.result.ok -and
    $_.scope.task -eq '01_verify_installed_tools.md'
})
if ($completedEvents.Count -ne 1) {
    throw "fresh-process activity has $($completedEvents.Count) matching task.completed events, expected one"
}
$log = (Invoke-Native $git @('-C', $saved.camp, 'log', '-1', '--format=%s')).Output.Trim()
if ($log -notmatch 'Verify installed Windows beginner journey') {
    throw "fresh-process Git log lost festival commit: $log"
}
Write-Host "fresh-process camp HEAD: $readHead"
Write-Host 'fresh-process linked project, fest next, task progress/activity, and Git commit: OK'
Assert-FirstRunSetupReadback
Write-Host 'Windows installed beginner journey readback: PASS'
