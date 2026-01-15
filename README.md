# OpenTofu Axiom Module

[![OpenTofu](https://img.shields.io/badge/OpenTofu-FFDA18?logo=opentofu&logoColor=black)](https://opentofu.org/)
[![Axiom](https://img.shields.io/badge/Axiom-000000?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0iI2ZmZiIgZD0iTTEyIDJMMiAyMmgyMEwxMiAyeiIvPjwvc3ZnPg==)](https://axiom.co)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/your-org/terraform-axiom-module?color=green)](https://github.com/your-org/terraform-axiom-module/releases)

[![Buildkite](https://img.shields.io/buildkite/your-buildkite-badge-id/main?logo=buildkite&label=build)](https://buildkite.com/your-org/terraform-axiom-module)
[![CodeRabbit](https://img.shields.io/badge/CodeRabbit-Enabled-blue?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0iI2ZmZiIgZD0iTTEyIDRjLTQuNDIgMC04IDMuNTgtOCA4czMuNTggOCA4IDggOC0zLjU4IDgtOC0zLjU4LTgtOC04eiIvPjwvc3ZnPg==)](https://coderabbit.ai)
[![Security](https://img.shields.io/badge/Security-Trivy-1904DA?logo=aquasecurity&logoColor=white)](https://trivy.dev/)
[![Checkov](https://img.shields.io/badge/Checkov-Passing-4CAF50?logo=paloaltonetworks&logoColor=white)](https://www.checkov.io/)

---

OpenTofu module for configuring [Axiom](https://axiom.co) observability resources including datasets, monitors, notifiers, and users.

## ✨ Features

- 📊 Create and manage Axiom datasets
- 🔔 Configure monitors with alerting thresholds
- 📣 Set up notifiers (Slack, PagerDuty, Email, Webhooks)
- 👥 Manage users and API tokens
- 🌍 Support for multiple environments

## 📋 Requirements

| Name | Version |
|------|---------|
| ![OpenTofu](https://img.shields.io/badge/-OpenTofu-FFDA18?logo=opentofu&logoColor=black&style=flat-square) | `>= 1.6.0` |
| ![Axiom](https://img.shields.io/badge/-Axiom-000000?style=flat-square) | `>= 0.3.0` |

## 🚀 Usage

### Basic Dataset

```hcl
module "axiom" {
  source  = "your-org/axiom/axiom"
  version = "1.0.0"

  datasets = {
    application_logs = {
      description = "Application logs from production services"
    }
    security_events = {
      description = "Security and audit events"
    }
  }
}
```

### Dataset with Monitor and Slack Notifier

```hcl
module "axiom" {
  source  = "your-org/axiom/axiom"
  version = "1.0.0"

  datasets = {
    error_logs = {
      description = "Error logs from all services"
    }
  }

  notifiers = {
    slack_alerts = {
      type = "slack"
      properties = {
        webhook_url = var.slack_webhook_url
        channel     = "#alerts"
      }
    }
  }

  monitors = {
    high_error_rate = {
      dataset     = "error_logs"
      description = "Alert when error rate exceeds threshold"
      query       = "| where level == 'error' | summarize count() by bin_auto(_time)"
      threshold   = 100
      frequency   = "5m"
      range       = "5m"
      operator    = "above"
      notifiers   = ["slack_alerts"]
    }
  }
}
```

### Complete Example with Multiple Resources

```hcl
module "axiom" {
  source  = "your-org/axiom/axiom"
  version = "1.0.0"

  # 📊 Datasets
  datasets = {
    app_logs = {
      description = "Application logs"
    }
    metrics = {
      description = "Infrastructure metrics"
    }
    traces = {
      description = "Distributed traces"
    }
  }

  # 📣 Notifiers
  notifiers = {
    slack_critical = {
      type = "slack"
      properties = {
        webhook_url = var.slack_critical_webhook
        channel     = "#critical-alerts"
      }
    }
    pagerduty = {
      type = "pagerduty"
      properties = {
        routing_key = var.pagerduty_routing_key
        severity    = "critical"
      }
    }
    email_team = {
      type = "email"
      properties = {
        emails = ["team@example.com", "oncall@example.com"]
      }
    }
  }

  # 🔔 Monitors
  monitors = {
    error_spike = {
      dataset     = "app_logs"
      description = "Error count spike detection"
      query       = "| where level == 'error' | summarize count() by bin_auto(_time)"
      threshold   = 50
      frequency   = "5m"
      range       = "10m"
      operator    = "above"
      notifiers   = ["slack_critical", "pagerduty"]
    }
    latency_p99 = {
      dataset     = "traces"
      description = "P99 latency threshold breach"
      query       = "| summarize percentile(duration_ms, 99) by bin_auto(_time)"
      threshold   = 1000
      frequency   = "5m"
      range       = "15m"
      operator    = "above"
      notifiers   = ["slack_critical"]
    }
  }

  # 🔑 API Tokens
  api_tokens = {
    ingest_token = {
      description = "Token for log ingestion"
      scopes      = ["ingest"]
      datasets    = ["app_logs", "metrics", "traces"]
    }
    query_token = {
      description = "Token for querying data"
      scopes      = ["query"]
      datasets    = ["app_logs", "metrics", "traces"]
    }
  }

  tags = {
    Environment = "production"
    Team        = "platform"
    ManagedBy   = "opentofu"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## 📥 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `datasets` | Map of Axiom datasets to create | `map(object({ description = string }))` | `{}` | no |
| `monitors` | Map of Axiom monitors to create | `map(object({ dataset = string, description = string, query = string, threshold = number, frequency = string, range = string, operator = string, notifiers = list(string) }))` | `{}` | no |
| `notifiers` | Map of Axiom notifiers to create | `map(object({ type = string, properties = map(string) }))` | `{}` | no |
| `api_tokens` | Map of API tokens to create | `map(object({ description = string, scopes = list(string), datasets = list(string) }))` | `{}` | no |
| `tags` | Tags to apply to all resources | `map(string)` | `{}` | no |

## 📤 Outputs

| Name | Description |
|------|-------------|
| `dataset_ids` | Map of dataset names to their IDs |
| `dataset_names` | List of created dataset names |
| `monitor_ids` | Map of monitor names to their IDs |
| `notifier_ids` | Map of notifier names to their IDs |
| `api_token_ids` | Map of API token names to their IDs (sensitive) |
<!-- END_TF_DOCS -->

## ⚙️ Provider Configuration

Configure the Axiom provider in your root module:

```hcl
terraform {
  required_providers {
    axiom = {
      source  = "axiomhq/axiom"
      version = "~> 0.3.0"
    }
  }
}

provider "axiom" {
  api_token = var.axiom_api_token  # Or set AXIOM_TOKEN env var
  org_id    = var.axiom_org_id     # Or set AXIOM_ORG_ID env var
}
```

## 📂 Examples

| Example | Description |
|---------|-------------|
| [🟢 Basic](./examples/basic) | Single dataset setup |
| [🔵 Complete](./examples/complete) | Full configuration with monitors and notifiers |
| [🟣 Multi-Environment](./examples/multi-env) | Environment-specific configurations |

## 🔄 Migration Guide

### v0.x → v1.0

> ⚠️ **Breaking changes in v1.0**

| Change | Before (v0.x) | After (v1.0) |
|--------|---------------|--------------|
| Datasets | `dataset_name` | `datasets` (map) |
| Monitors | `monitor` | `monitors` (map) |
| Notifiers | `notifier_config` | `notifiers` (map) |

```hcl
# ❌ Before (v0.x)
module "axiom" {
  source       = "your-org/axiom/axiom"
  version      = "0.5.0"
  dataset_name = "logs"
}

# ✅ After (v1.0)
module "axiom" {
  source  = "your-org/axiom/axiom"
  version = "1.0.0"
  datasets = {
    logs = {
      description = "Log dataset"
    }
  }
}
```

## 🤝 Contributing

1. 🍴 Fork the repository
2. 🌿 Create a feature branch (`git checkout -b feat/new-feature`)
3. 💾 Commit changes using [Conventional Commits](https://www.conventionalcommits.org/)
4. 📤 Push to the branch (`git push origin feat/new-feature`)
5. 🔃 Open a Pull Request

### 📝 Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

| Type | Description |
|------|-------------|
| `feat` | ✨ New feature |
| `fix` | 🐛 Bug fix |
| `docs` | 📚 Documentation |
| `refactor` | ♻️ Code refactoring |
| `test` | 🧪 Tests |
| `chore` | 🔧 Maintenance |

**Scopes:** `datasets`, `monitors`, `notifiers`, `tokens`, `examples`, `docs`

### 🛠️ Local Development

```bash
# 🎨 Format code
tofu fmt -recursive

# ✅ Validate
tofu validate

# 📖 Generate docs
terraform-docs markdown table . > README.md

# 🧪 Run tests
cd examples/basic && tofu init && tofu plan
```

## 📄 License

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

Apache 2.0 - See [LICENSE](LICENSE) for details.

## 👥 Authors

Maintained by **Your Organization**.

## 🔗 Related

| Resource | Link |
|----------|------|
| 📖 Axiom Documentation | [axiom.co/docs](https://axiom.co/docs) |
| 🔌 Axiom Provider | [Registry](https://registry.terraform.io/providers/axiomhq/axiom/latest/docs) |
| 🔧 Axiom API Reference | [API Docs](https://axiom.co/docs/restapi/introduction) |
| 🟡 OpenTofu | [opentofu.org](https://opentofu.org/) |
| 🟢 Buildkite | [buildkite.com](https://buildkite.com/) |

---

<p align="center">
  <sub>Built with ❤️ using <img src="https://img.shields.io/badge/-OpenTofu-FFDA18?logo=opentofu&logoColor=black&style=flat-square" alt="OpenTofu" /> and <img src="https://img.shields.io/badge/-Buildkite-14CC80?logo=buildkite&logoColor=white&style=flat-square" alt="Buildkite" /></sub>
</p>
