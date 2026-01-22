$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Get-Command tofu -ErrorAction SilentlyContinue)) {
  Write-Host "[skip] tofu not installed"
  exit 0
}

$staged = git diff --cached --name-only
if (-not ($staged | Where-Object { $_ -match '\.tf$' })) {
  Write-Host "[skip] tofu-validate: no staged .tf files"
  exit 0
}

tofu init -backend=false -input=false -no-color 2>&1 | ForEach-Object { Write-Host $_ }
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

tofu validate -no-color 2>&1 | ForEach-Object { Write-Host $_ }
exit $LASTEXITCODE
