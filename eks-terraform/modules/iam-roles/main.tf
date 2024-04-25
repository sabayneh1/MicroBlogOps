resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-${var.cluster_name}"
  # Creates a role with a name linked to your cluster name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  # Defines a trust policy allowing the EKS control plane
  # to assume this role for managing the cluster on your behalf
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
  # Attaches the AWS-managed AmazonEKSClusterPolicy, granting
  # permissions needed for EKS cluster operations
}

resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group-${var.cluster_name}"
  # Creates a role for your worker nodes

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  # Allows EC2 instances to assume this role, a prerequisite
  # for joining the EKS cluster
}

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
  # Attaches the AmazonEKSWorkerNodePolicy for EKS related actions
}

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
  # Grants permissions necessary for the EKS CNI (networking) plugin
}

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
  # Provides read-only access to pull images from ECR
}

