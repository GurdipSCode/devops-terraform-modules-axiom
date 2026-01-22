$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Get-Command ggshield -ErrorAction SilentlyContinue)) {
  Write-Host "[skip] ggshield not installed"
  exit 0
}

$out = ggshield secret scan pre-commit
$code = $LASTEXITCODE

$out | ForEach-Object { Write-Host $_ }

if ($code -ne 0) {
  Write-Host "[fail] ggshield exited with code $code"
}

exit $code
