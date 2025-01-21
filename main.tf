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

# Boilerplate tutorial code, for testing terraform / aws connectivity
# resource "aws_instance" "app_server" {
#   ami           = "ami-0df8c184d5f6ae949" # Amazon Linux, free tier, us-east-1 from AMI catalogue in EC2 page
#   instance_type = "t2.micro"

#   tags = {
#     # to override via commandline: terraform apply -var "instance_name=YetAnotherName"
#     Name = var.instance_name
#   }
# }

module "private_tf" {
  source = "./private_tf"
}


# Bucket for uploading images
resource "aws_s3_bucket" "imgup-uploads" {
  bucket = module.private_tf.imgup_s3_bucket_output
  acl    = "private" # TODO change / analyze. Setting to public throws the error "Error: creating Amazon S3 (Simple Storage) Bucket (imgup-uploads): InvalidBucketAclWithObjectOwnership: Bucket cannot have ACLs set with ObjectOwnership's BucketOwnerEnforced setting"
  # policy 

  tags = {
    Name = "Image upload bucket"
    # Environment = "Dev"
  }

  # TODO: research this, is deprecated: "Use the aws_s3_bucket_versioning resource instead"
  versioning {
    enabled = false
  }
}

# Hello World image for that bucket for testing
# This failed the first time, a second apply got it - need some explicit dependency on the bucket or something?
resource "aws_s3_object" "hello_world_image" {
  bucket = module.private_tf.imgup_s3_bucket_output
  key    = "hello_world"
  source = "hello_world.jpg"

  # (Optional) Triggers updates when the value changes. The only meaningful value is filemd5("path/to/file")
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  # etag = filemd5("path/to/file")
}