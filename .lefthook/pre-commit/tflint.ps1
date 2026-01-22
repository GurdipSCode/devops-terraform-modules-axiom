$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Get-Command tflint -ErrorAction SilentlyContinue)) {
  Write-Host "[skip] tflint not installed"
  exit 0
}

tflint --init --no-color 2>&1 | ForEach-Object { Write-Host $_ }
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

tflint --no-color 2>&1 | ForEach-Object { Write-Host $_ }
exit $LASTEXITCODE
