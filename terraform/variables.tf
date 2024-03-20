variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "ca-central-1" # Change to your desired AWS region
}

# variable "ec2_count" {
#   description = "Number of EC2 instances to create."
#   type        = number
#   default     = 2
# }

# variable "ec2_ami" {
#   description = "AMI ID for EC2 instances."
#   type        = string
#   default     = "ami-0fb99f22ad0184043"
# }

# variable "ec2_instance_type" {
#   description = "Type of EC2 instance."
#   type        = string
#   default     = "t2.micro"
# }
