variable "vpc_name" {
  type    = string
  default = "Kube-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type    = list(string)
  default = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.200.0/24", "10.0.201.0/24", "10.0.202.0/24"]
}
variable "vpc_enable_nat_gateway" {
  type    = bool
  default = true
}

variable "vpc_tags" {
  type    = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "enable_nat_gateway" { default = false }

