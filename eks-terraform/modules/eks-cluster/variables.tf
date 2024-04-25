variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "TestOne"  # Replace with your desired default cluster name
}

variable "key_name" {
  description = "Key name of the SSH key pair for EC2 instances."
  type        = string
  default     = "pro1"  # Replace with your desired default key name
}


# Inside modules/eks-cluster/variables.tf

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed."
  type        = string
}

variable "private_subnets" {
  description = "The private subnets for the EKS cluster."
  type        = list(string)
}
