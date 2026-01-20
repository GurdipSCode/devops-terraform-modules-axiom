variable "create_notifier" {
  type    = bool
  default = false
}

variable "notifier_name" {
  type    = string
  default = null
}

variable "notifier_type" {
  type    = string
  default = "slack"
}

variable "notifier_properties" {
  type    = any
  default = null
}
