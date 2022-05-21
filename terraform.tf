terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
    archive = {
      version = "~> 2.2.0"
    }
  }
}

provider "archive" {}

provider "aws" {
  region  = "us-east-1"
}

provider "aws" {
  alias   = "region"
  region  = var.region
}