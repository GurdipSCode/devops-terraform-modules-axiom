$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Get-Command tofu -ErrorAction SilentlyContinue)) {
  Write-Host "[skip] tofu not installed"
  exit 0
}

tofu test -no-color 2>&1 | ForEach-Object { Write-Host $_ }
exit $LASTEXITCODE
