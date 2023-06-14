Set-StrictMode -Version latest

# `e was added in PowerShell 6, so using  directly instead

function Write-InRed {
  Write-Output "[31m$args[0m"
}
