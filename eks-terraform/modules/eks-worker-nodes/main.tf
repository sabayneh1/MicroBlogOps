resource "aws_launch_configuration" "eks_workers" {
  name_prefix = "${var.cluster_name}-"
  # Creates a unique name for the launch configuration (e.g., 'my-cluster-workers')

  image_id = var.worker_ami_id
  # Specifies the Amazon Machine Image (AMI) to use for worker nodes

  instance_type = var.worker_instance_type
  # Sets the EC2 instance type for worker nodes

  key_name = var.key_name
  # Specifies the SSH key for accessing worker nodes

  security_groups = var.security_group_id
  # Assigns security groups to the instances for network access control

  user_data = <<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
    EOF
  # Provides a script that runs on node launch, configuring them to join the ECS cluster

  lifecycle {
    create_before_destroy = true
    # Ensures a new launch configuration is ready before destroying the old one (important for zero-downtime updates)
  }
}

resource "aws_autoscaling_group" "eks_workers" {
  launch_configuration = aws_launch_configuration.eks_workers.id
  # Links the ASG to the launch configuration, defining how to launch instances

  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  # Manages the scaling parameters of the worker node group

  vpc_zone_identifier = var.private_subnets
  # Specifies the subnets in which to launch instances

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-worker"
    propagate_at_launch = true
    # Adds a descriptive name tag to the instances
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
    # Adds a Kubernetes-specific tag for identification
  }
}
