# PowerShell 5.1 + 7 compatible, plain output, no emojis
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$InformationPreference = 'Continue'

# PS7+ only
if ($PSVersionTable.PSVersion.Major -ge 7) {
  $PSStyle.OutputRendering = 'PlainText'
}

# Stable encoding for redirected/captured output
try {
  [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
} catch {
  # ignore if not supported
}

function Write-Info([string]$Message) { Write-Host "INFO: $Message" }
function Write-Warn([string]$Message) { Write-Host "WARN: $Message" }

if (-not (Get-Command tofu -ErrorAction SilentlyContinue)) {
  Write-Warn 'tofu not installed, skipping'
  exit 0
}

# Only run if any staged .tf exists
$staged = @(
  git diff --cached --name-only --diff-filter=ACMR 2>$null
)

if (-not ($staged | Where-Object { $_ -match '\.tf$' })) {
  Write-Info 'tofu-fmt: no staged .tf files; skipping'
  exit 0
}

tofu fmt -check -recursive
