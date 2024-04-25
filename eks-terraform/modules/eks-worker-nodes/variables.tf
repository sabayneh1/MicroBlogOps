variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "worker_ami_id" {
  description = "AMI ID for the worker nodes."
  type        = string
  default = "ami-0fb99f22ad0184043"
}

variable "worker_instance_type" {
  description = "Instance type for the worker nodes."
  type        = string
}

variable "min_size" {
  description = "Minimum size of the worker node group."
  type        = number
}

variable "max_size" {
  description = "Maximum size of the worker node group."
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the worker node group."
  type        = number
}

variable "subnets" {
  description = "List of subnet IDs for the worker nodes."
  type        = list(string)
}


variable "key_name" {
  description = "The name of the SSH key pair to use for the worker nodes."
  type        = string
}



variable "security_group_id" {
  description = "The IDs of the security groups to use for the EKS worker nodes."
  type        = list(string)
}



variable "private_subnets" {
  description = "The private subnets for the EKS cluster."
  type        = list(string)
}
