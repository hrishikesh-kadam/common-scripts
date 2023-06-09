function PrintInRed($message) {
  [Console]::ForegroundColor = 'red'
  [Console]::Error.WriteLine($message)
  [Console]::ResetColor()
}
