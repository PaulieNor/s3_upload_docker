terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11.0"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket         = var.remote_state_store
    key            = "upload_s3/terraform.tfstate"
    region         = var.aws_region
    profile        = var.aws_profile
    dynamodb_table = "${var.env}_tf_state_lock"
    encrypt        = true
  }
}


provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}