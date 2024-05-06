variable "env" {

  type    = string
  default = "dev"
}


variable "aws_profile" {
  description = "(Optional) AWS profile to use. If not specified, the default profile will be used."
  type = string
  default = "default"
}

variable "aws_region" {
  description = "AWS Region."
  type = string
  default = "eu-west-2"
}

variable "account_id" {
  type = string
}

variable "additional_tags" {
  

  default = {
    ManagedBy = "Terraform"
  }
}