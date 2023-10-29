terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      Stack       = "node-react-demo"
      Environment = "staging"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "node-react-demo-staging-tf-state"
    key            = "tf-state"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "node-react-demo-staging-lock-table"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/28"

  tags = {
    Name = "main-vpc"
  }
}
