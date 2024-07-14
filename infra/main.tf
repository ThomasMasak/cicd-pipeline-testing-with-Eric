terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "03thomasmasak-testing"
    workspaces {
      name = "ec2-test"
    }
  }

}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-3"
}