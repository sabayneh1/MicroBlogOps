data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  unique_suffix = format("%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
}


# IAM Role for Worker Nodes
resource "aws_iam_role" "ec2_role_worker" {
  name = "micro-blog-k8s-node-role-${local.unique_suffix}-worker"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

# IAM Policy for Worker Nodes
resource "aws_iam_policy" "ec2_policy_worker" {
  name        = "micro-blog-k8s-node-policy-${local.unique_suffix}-worker"
  description = "IAM policy for Kubernetes worker nodes"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:*",
        Resource = "*",
      },
      {
        Effect   = "Allow",
        Action   = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2:DescribeNetworkInterfaces",
          # Additional actions specific to worker nodes can be added here
        ],
        Resource = "*",
      },
    ],
  })
}

# Policy Attachment for Worker Nodes
resource "aws_iam_policy_attachment" "ec2_policy_attachment_worker" {
  name       = "micro-blog-k8s-node-policy-attachment-${local.unique_suffix}-worker"
  policy_arn = aws_iam_policy.ec2_policy_worker.arn
  roles      = [aws_iam_role.ec2_role_worker.name]
}

# IAM Instance Profile for Worker Nodes
resource "aws_iam_instance_profile" "ec2_profile_worker" {
  name = "micro-blog-ec2-profile-${local.unique_suffix}-worker"
  role = aws_iam_role.ec2_role_worker.name
}

# Assuming you have a variable `worker_instance_count` for the number of worker nodes
# EC2 Instances for Kubernetes Worker Nodes

resource "aws_instance" "k8s_worker_node" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = element(var.private_subnet_ids, count.index % length(var.private_subnet_ids))
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile_worker.name
  associate_public_ip_address = false  # Typically false for worker nodes in private subnets
  tags = {
    "Name" = "k8s-worker-${count.index}"
  }
}


# resource "null_resource" "update_ansible_inventory_and_run_playbook" {
#   depends_on = [
#     aws_instance.k8s_worker_node,
#     aws_instance.k8s_node # Assuming this is your master node
#   ]

#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = <<EOT
# echo "[master]" > ../ansible/hosts.ini
# echo "${aws_instance.k8s_node.public_ip}" >> ../ansible/hosts.ini
# echo "[workers]" >> ../ansible/hosts.ini
# %{ for ip in aws_instance.k8s_worker_node.*.public_ip ~}
# echo "${ip}" >> ../ansible/hosts.ini
# %{ endfor ~}
# ansible-playbook -i ../ansible/hosts.ini ../ansible/k8s-setup.yml --private-key /path/to/your/private/key
# EOT
#   }
# }
