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

# I know it's terrible to have a single EC2 instance without ASG/ALB, in default vpc, etc....
# I'm poor though and we don't have customer so leave me alone !
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.5"

  name = "node-react-demo"

  instance_type     = "t4g.micro"
  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2"

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    systemctl start docker
    systemctl enable docker
  EOF

}

resource "aws_ecr_repository" "backend" {
  name = var.backend_repository_name

  image_tag_mutability = "IMMUTABLE"
}
