data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  unique_suffix = format("%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_name       = "my-vpc"
  vpc_cidr       = "10.0.0.0/16"
  vpc_azs        = ["ca-central-1a", "ca-central-1b"]
  public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

}


module "master_node" {
  source                = "./modules/ec2-master"
  ami                   = "ami-0fb99f22ad0184043"
  instance_type         = "t2.medium"
  subnet_id             = module.vpc.public_subnet_ids[0]
  security_group_ids    = [module.vpc.master_security_group_id]
  key_name              = "pro1"
  instance_count        = 1
  tags                  = { Name = "k8s-master" }
  iam_instance_profile_name= "micro-blog-ec2-profile-${local.unique_suffix}"
}

module "worker_nodes" {
  source                = "./modules/ec2-worker"
  ami                   = "ami-0fb99f22ad0184043"
  instance_type         = "t2.medium"
  subnet_id             = module.vpc.public_subnet_ids[0]
  security_group_ids    = [module.vpc.worker_security_group_id]
  key_name              = "pro1"
  instance_count        = 2 
  tags                  = { Name = "k8s-worker" }
  iam_instance_profile_name = "micro-blog-ec2-profile-${local.unique_suffix}-worker"
  private_subnet_ids       = module.vpc.private_subnet_ids
}

























# module "linux" {
#   source = "./modules/linux"
#   #   version                = "~> 2.0"

#   instance_count = 2

#   ami           = "ami-0fb99f22ad0184043"
#   instance_type = "t2.micro"
#   #   key_name               = "user1"
#   #   monitoring             = true
#   #   vpc_security_group_ids = ["sg-12345678"]
#   #   subnet_id              = "subnet-eddcdzz4"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }


# module "linux" {
#   source = "./modules/linux"

#   linux_instances = {
#     linux-ubuntu-vm  = { instance_type = "t2.micro", ami = "ami-0fb99f22ad0184043" }
#     linux-ubuntu-vm1 = { instance_type = "t2.micro", ami = "ami-0fb99f22ad0184043" }
#   }
# }


