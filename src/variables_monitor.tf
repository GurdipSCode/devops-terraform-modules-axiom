variable "create_monitor" {
  type    = bool
  default = false
}

variable "monitor_type" {
  type    = string
  default = "Threshold"
}

variable "monitor_name" {
  type    = string
  default = null
}

variable "monitor_description" {
  type    = string
  default = null
}

variable "monitor_apl_query" {
  type    = string
  default = null
}

variable "monitor_interval_minutes" {
  type    = number
  default = 5
}

variable "monitor_range_minutes" {
  type    = number
  default = 5
}

variable "monitor_operator" {
  type    = string
  default = null
}

variable "monitor_threshold" {
  type    = number
  default = null
}

variable "monitor_compare_days" {
  type    = number
  default = null
}

variable "monitor_tolerance" {
  type    = number
  default = null
}

variable "monitor_notifier_ids" {
  type    = list(string)
  default = []
}

variable "monitor_alert_on_no_data" {
  type    = bool
  default = false
}

variable "monitor_notify_by_group" {
  type    = bool
  default = false
}
