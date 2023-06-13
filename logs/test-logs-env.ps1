Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

. "$env:COMMON_SCRIPTS_ROOT\logs\logs-env.ps1"

Write-Output "Testing test-logs-env.ps1"
Write-Output "------------------------------------"

Write-InRed "Print in red"

Write-Output "------------------------------------"
