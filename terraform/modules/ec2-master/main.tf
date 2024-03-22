data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  unique_suffix = format("%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
}

# Shared IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_role" {
  name = "micro-blog-k8s-node-role-${local.unique_suffix}"

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

# Shared IAM Policy for EC2 Instances
resource "aws_iam_policy" "ec2_policy" {
  name        = "micro-blog-k8s-node-policy-${local.unique_suffix}"
  description = "IAM policy for Kubernetes nodes"

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
          # Additional actions for Kubernetes nodes
        ],
        Resource = "*",
      },
    ],
  })
}

# Policy Attachment
resource "aws_iam_policy_attachment" "ec2_policy_attachment" {
  name       = "micro-blog-k8s-node-policy-attachment-${local.unique_suffix}"
  policy_arn = aws_iam_policy.ec2_policy.arn
  roles      = [aws_iam_role.ec2_role.name]
}

# Shared IAM Instance Profile for EC2 Instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "micro-blog-ec2-profile-${local.unique_suffix}"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instances for Kubernetes Nodes
resource "aws_instance" "k8s_node" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile_name
  associate_public_ip_address = true
  tags                        = var.tags

 provisioner "file" {
  source      = "${path.module}/../../pro1.pem"
  destination = "/home/ubuntu/pro1.pem"

  connection {
    type        = "ssh"
    user        = "ubuntu" # Adjusted to 'ubuntu' as your Ansible user is 'ubuntu'
    private_key = file("${path.module}/../../pro1.pem")
    host        = self.public_ip
  }
}



}





# resource "null_resource" "master_node_setup" {
#   depends_on = [
#     aws_instance.k8s_node # Assuming this is your master node
#   ]

#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = <<EOT
# echo "[master]" > ../ansible/hosts.ini
# echo "${aws_instance.k8s_node.public_ip}" >> ../ansible/hosts.ini

# # Run Ansible playbook or tasks specifically for the master node setup
# ansible-playbook -i ../ansible/hosts.ini ../ansible/path/to/master-setup-playbook.yml --private-key /path/to/your/private/key
# EOT
#   }
# }
