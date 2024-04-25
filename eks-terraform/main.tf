module "vpc" {
  source = "./modules/vpc"
  # Uses a custom VPC module from within your project directory

  # Variables specific to your VPC module (would need the module code to know these)
}

module "iam-roles" {
  source = "./modules/iam-roles"
  # Uses a custom IAM roles module

  cluster_name = var.cluster_name
  # Passes the cluster name variable to the IAM module
}

module "eks-cluster" {
  source = "./modules/eks-cluster"
  # Uses a custom EKS cluster configuration module

  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  key_name     = var.key_name
  # Integrates with the VPC module for networking resources
  
  depends_on = [ module.vpc, module.iam-roles ]
  # Ensures VPC and IAM resources are created first
}

# Optional module for EKS worker node management
module "eks-worker-nodes" {
  source = "./modules/eks-worker-nodes"

  cluster_name         = var.cluster_name
  worker_ami_id        = var.worker_ami_id
  worker_instance_type = var.worker_instance_type
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  subnets              = module.vpc.private_subnets
  key_name             = "pro1"
  security_group_id    = [module.vpc.eks_cluster_sg_id]

  private_subnets      = module.vpc.private_subnets

  depends_on = [module.vpc, module.iam-roles, module.eks-cluster]
}

# External Data Source
data "external" "fetch_kube_token" {
  program = ["sh", "-c", "aws eks get-token --cluster-name ${var.cluster_name} | jq -c '{token: .status.token}'"]
  # Fetches an EKS authentication token using the AWS CLI and 'jq'
}
