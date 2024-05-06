terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11.0"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket         = "dev-upload-remote-state-store-2222"
    key            = "upload_s3/terraform.tfstate"
    profile = "default"
    region  = "eu-west-2"
    dynamodb_table = "dev-s3-upload-tfm-lock"
    encrypt        = true
  }
}


provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}