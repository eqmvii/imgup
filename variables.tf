variable "instance_name" {
  description = "Name tag for EC2"
  type        = string
  default     = "ExampleAppServerInstance"
}

# actual var in private_tf folder
# variable "imgup_s3_bucket" {
#   description = "Name tag for EC2"
#   type        = string
#   default     = "$BUCKET_NAME"
# }