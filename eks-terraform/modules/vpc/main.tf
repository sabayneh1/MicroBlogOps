module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  # Uses a pre-built module for faster VPC creation

  version = "~> 5.6"

  name = "eks-vpc"
  # Gives your VPC a descriptive name

  cidr = "10.0.0.0/16"
  # Defines the main CIDR block for the VPC

  azs = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  # Distributes subnets across multiple availability zones

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  # Specifies CIDR blocks for private and public subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  # Configures NAT gateways for private subnets to access the internet

  tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    # Adds a tag for Kubernetes integration
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id
  # Associates the security group with your VPC

  ingress {
    description = "Allow all inbound traffic"
    # CAUTION: This is very open for development; tighten for production!
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    # Allows unrestricted outbound connection from the cluster
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
    "kubernetes.io/cluster/eks-cluster" = "owned"
  }
}
