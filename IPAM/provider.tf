provider "aws" {
  region = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "your-profile"
  default_tags {
    tags = {
      Terraform = true
    }
  }
}

terraform {
  required_version = "~> 1.1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.68" #The IPAM commands just work using this version
    }
  }
}
