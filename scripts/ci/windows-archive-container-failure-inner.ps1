#Requires -Version 5.1
param([Parameter(Mandatory = $true)][string]$WorkRoot)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$fixture = Join-Path $WorkRoot 'intentional-failure-fixture.txt'
[IO.File]::WriteAllText($fixture, 'container-only')
if ([IO.File]::ReadAllText($fixture) -cne 'container-only') {
    throw 'controlled failure fixture could not be read inside the container'
}
throw 'intentional Windows inner-proof failure'
