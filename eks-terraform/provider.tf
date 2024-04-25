terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      # Specifies the AWS provider and version constraint
    }
  }

  required_version = ">= 0.14.9"
  # Specifies the minimum required Terraform CLI version
}

provider "aws" {
  # profile = "default"
  # Uses AWS credentials stored in the "default" profile
  region  = "ca-central-1"
  # Deploys resources in the ca-central-1 region
}

provider "kubernetes" {
  host = module.eks-cluster.cluster_endpoint
  # Connects to the EKS cluster endpoint provided by the "eks-cluster" module
  cluster_ca_certificate = base64decode(module.eks-cluster.cluster_ca_certificate)
  # Uses the cluster's CA certificate (decoded from base64) for authentication
  token = data.external.fetch_kube_token.result["token"]
  # Retrieves a Kubernetes authentication token using an external data source
}

