locals {

  custom_tags = data.aws_default_tags.default.tags

  acc_4_chars = substr(var.aws_account_id, -4, 4)
}