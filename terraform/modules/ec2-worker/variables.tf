variable "ami" {
  type    = string
  default = "ami-0fb99f22ad0184043"  # Ensure this AMI is appropriate for your region and Kubernetes setup
}

variable "instance_type" {
  type    = string
  # default = "t2.micro"  # Consider the requirements of your Kubernetes nodes; t2.micro may be insufficient for production
}

variable "subnet_id" {
  type    = string
  // No default provided; this should be specified based on your VPC configuration
}

variable "security_group_ids" {
  type    = list(string)
  description = "List of Security Group IDs to attach to the EC2 instance"
  // default value can be set or passed at runtime
}

variable "key_name" {
  type    = string
  // No default provided; this should be the name of an existing EC2 Key Pair
}

variable "instance_count" {
  type    = number
  # default = 1  // Adjust based on how many instances you want to provision for each role (master/worker)
}

variable "tags" {
  type    = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "iam_instance_profile_name" {
  description = "The IAM instance profile name to attach to the EC2 instances"
  type        = string
}


variable "private_subnet_ids" {
  description = "List of IDs for private subnets across different AZs"
  type        = list(string)
}
