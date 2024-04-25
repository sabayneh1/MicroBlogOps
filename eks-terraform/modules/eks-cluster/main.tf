module "eks" {
  source            = "terraform-aws-modules/eks/aws"
  # Specifies the source of the pre-built EKS module

  version           = "~> 17.0.3"
  # Ensures compatibility with minor updates of the module


  cluster_name      = var.cluster_name
  # Provides a custom name for your EKS cluster

  cluster_version   = "1.29"
  # Sets the desired Kubernetes version

  subnets           = var.private_subnets
  # Specifies private subnets for worker node placement

  vpc_id            = var.vpc_id
  # Indicates the VPC where the cluster will be created


  node_groups = {
    example = {
      desired_capacity = 2
      # Sets the initial number of nodes in the group

      max_capacity     = 3
      # Sets the upper limit for autoscaling

      min_capacity     = 1
      # Ensures at least one node is always available

      instance_type    = "m5.large"
      # Specifies the EC2 instance type for worker nodes

      key_name         = var.key_name
      # Provides the SSH key pair for accessing the nodes
    }
  }

  tags = {
    Environment = "development"
    # Adds an identifying tag to the cluster resources
  }

  # Enables automatic configuration of kubeconfig for cluster access
  manage_aws_auth = true
}

