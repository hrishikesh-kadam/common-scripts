# `e was added in Powershell 6, so using  directly instead

function PrintInRed {
  Write-Output "[31m$args[0m"
}
