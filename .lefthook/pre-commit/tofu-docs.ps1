# PowerShell 5.1 + 7 compatible, plain output, no emojis
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$InformationPreference = 'Continue'

# PS7+ only: prevent ANSI/control sequences when output is captured
if ($PSVersionTable.PSVersion.Major -ge 7) {
  $PSStyle.OutputRendering = 'PlainText'
}

# Stable UTF-8 output for hook runners/captured logs
try {
  [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
  $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
} catch {
  # ignore if not supported
}

function Write-Info([string]$Message) { Write-Host "INFO: $Message" }
function Write-Warn([string]$Message) { Write-Host "WARN: $Message" }
function Write-Fail([string]$Message) { Write-Host "FAIL: $Message" }

if (-not (Get-Command terraform-docs -ErrorAction SilentlyContinue)) {
  Write-Info 'skip: terraform-docs not installed'
  exit 0
}

$changed = @(
  git diff --cached --name-only --diff-filter=ACMR 2>$null
)

$needsDocs = $false
foreach ($f in $changed) {
  if ($f -match '\.tf$' -or $f -ieq 'README.md') {
    $needsDocs = $true
    break
  }
}

if (-not $needsDocs) {
  Write-Info 'skip: terraform-docs: no .tf or README.md changes staged'
  exit 0
}

# Generate docs and capture output (stdout+stderr)
$out = @(terraform-docs markdown table . 2>&1)
$code = $LASTEXITCODE

# Echo output for visibility
$out | ForEach-Object { Write-Host $_ }

if ($code -ne 0) {
  Write-Fail "terraform-docs exited with code $code"
  exit $code
}

# Write README in UTF-8 without BOM and re-stage it
$out | Out-File -FilePath 'OPENTOFU.md' -Encoding utf8
git add 'README.md' | Out-Null

exit 0
