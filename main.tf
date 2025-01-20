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
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0df8c184d5f6ae949" # Amazon Linux, free tier, us-east-1 from AMI catalogue in EC2 page
  instance_type = "t2.micro"

  tags = {
    # to override via commandline: terraform apply -var "instance_name=YetAnotherName"
    Name = var.instance_name
  }
}
