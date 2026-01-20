variable "create_user" {
  type    = bool
  default = false
}

variable "user_name" {
  type    = string
  default = null
}

variable "user_email" {
  type    = string
  default = null
}

variable "user_role" {
  type    = string
  default = "user"
}
