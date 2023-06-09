. $env:COMMON_SCRIPTS_ROOT\logs\set-logs-env.ps1

if (-not (Get-Module -ListAvailable PSScriptAnalyzer `
      -ErrorAction SilentlyContinue)) {
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
  Install-Module -Name PSScriptAnalyzer
  Get-InstalledModule PSScriptAnalyzer
}
