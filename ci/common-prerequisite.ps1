. $env:COMMON_SCRIPTS_ROOT\logs\set-logs-env.ps1

if (-not (Get-InstalledModule PSScriptAnalyzer -ErrorAction SilentlyContinue)) {
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
  Install-Module -Name PSScriptAnalyzer
  Get-InstalledModule PSScriptAnalyzer
}
