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


resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tpl", {
    master_ips       = [module.master_node.master_node_ip], # Ensure this is a list
    worker_ips       = module.worker_nodes.worker_node_ips, # No change here, it's already a list
    private_key_path = "${path.module}/pro1.pem"
  })
  filename = "${path.module}/../ansible/hosts.ini"
}

resource "null_resource" "configure_k8s" {
  // Explicitly declare dependencies on infrastructure resources
  depends_on = [
    local_file.ansible_inventory,
    module.master_node,
    module.worker_nodes,
    module.vpc,
    // Include here any other resources or modules your Ansible configuration depends on.
    // For example, if you have a module for your VPC or NAT Gateway, include them as well:

    // module.nat_gateway,
  ]

  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/../ansible/hosts.ini ${path.module}/../ansible/k8s-setup.yml --private-key ${path.module}/pro1.pem"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}



# # Removed: data "template_file" "ansible_hosts"
# # This data source is replaced by the use of the templatefile function directly in the local_file resource.

# resource "local_file" "ansible_inventory" {
#   # Updated to use templatefile function directly for content generation
#   content = templatefile("${path.module}/hosts.tpl", {
#     master_ips       = module.master_node.master_node_ip, # Assuming this outputs a single IP
#     worker_ips       = module.worker_nodes.worker_node_ips, # Directly pass the list without joining it into a string
#     private_key_path = "${path.module}/pro1.pem"
#   })
#   filename = "${path.module}/../ansible/hosts.ini"
# }

# resource "null_resource" "configure_k8s" {
#   depends_on = [local_file.ansible_inventory]

#   provisioner "local-exec" {
#     command = "ansible-playbook -i ${path.module}/../ansible/hosts.ini ${path.module}/../ansible/k8s-setup.yml --private-key ${path.module}/pro1.pem"
#     environment = {
#       ANSIBLE_HOST_KEY_CHECKING = "False"
#     }
#   }
# }
