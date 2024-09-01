variable "custom_tags" {
  description = "Custom tags to apply to all resources"
  type        = map(any)
  default     = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# ACM Certificate
# ---------------------------------------------------------------------------------------------------------------------
variable "subdomain" {
  description = "Subdomain"
  type = string
  default = ""
}
variable "domain" {
  description = "Domain"
  type = string
  default = ""
}

