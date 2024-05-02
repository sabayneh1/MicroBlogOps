# Microservices Deployment on Kubernetes

This repository is designed for deploying a commenting application using Kubernetes on AWS EC2 instances. The application utilizes Docker containers, managed through Kubernetes, with infrastructure as code handled by Terraform and Ansible.

# Diagram 
![mindmap](https://github.com/sabayneh1/MicroBlogOps/assets/59586300/6d7dc495-c2de-4e99-8c87-59d616de816c)

## Repository Structure

- **docker/** - Houses the Dockerfiles for building the application's images.
- **eks-terraform/** - Terraform scripts to establish an EKS cluster.
- **kube/** - Kubernetes configuration files for the application deployment.
- **terraform/** - Scripts for provisioning infrastructure on AWS, such as EC2 instances and it Contains playbooks and roles for setting up the Kubernetes cluster.

## Features in `kube/` Directory

- **Monitoring Stack**: Deploy Prometheus, Grafana, and Alertmanager for comprehensive monitoring.
- **Database Deployments**: Manage MySQL and PostgreSQL databases to support the application's data persistence needs.
- **Application Deployments**:
    - Deploy Ghost as a blogging platform and Commento for commenting functionality.
    - NGINX is used as an Ingress controller to manage external access to the services.
- **Networking**:
    - **Ingress**: NGINX Ingress controller for routing external traffic to the appropriate services.
    - **Services**: Kubernetes services to enable network access between the pods and from the external network.
- **Storage Solutions**: Use PVCs and AWS EFS for persistent data storage.
- **Horizontal Pod Autoscaling**: Automatically scale the number of pods based on CPU usage or other specified metrics.
- **Resource Management**:
    - **Resource Limits**: Define CPU and memory limits to ensure efficient resource usage.
    - **Affinities**:
        - **Pod Affinity and Anti-Affinity**: Ensure that pods are co-located on the same or different nodes based on requirements.
        - **Node Affinity**: Restrict nodes on which a pod can be scheduled, based on labels.

## Infrastructure as Code - Terraform and Ansible

### Overview

This project uses Terraform to provision the underlying infrastructure on AWS, including VPC, EC2 instances, and security groups, necessary for running a Kubernetes cluster. Ansible is then used to configure these instances to set up Kubernetes.

### Terraform

Terraform is used to create a VPC, subnets, and EC2 instances among other resources. The configuration is designed for high availability across multiple availability zones within the AWS Canada (Central) region.

### Key Terraform Modules

- **VPC Module**: Sets up a VPC with both public and private subnets spread across multiple availability zones, ensuring fault tolerance and high availability of the network infrastructure.
- **EC2 Instances**:
    - **Master Node**: Provisions EC2 instances that serve as Kubernetes master nodes. These instances are configured with necessary IAM roles and security groups to manage the cluster securely.
    - **Worker Nodes**: Provisions EC2 instances that serve as Kubernetes worker nodes, which will run the containerized applications.

### Security Groups

- **Master Security Group**: Configured to allow Kubernetes management traffic and SSH access.
- **Worker Security Group**: Allows traffic for Kubernetes worker nodes and SSH access.

### Ansible

Ansible is utilized post Terraform to configure Kubernetes on the provisioned EC2 instances. It sets up the Kubernetes cluster using the generated inventory of hosts.

### Ansible Playbooks

- **k8s-setup.yml**: Main playbook that installs and configures Kubernetes components on both master and worker nodes.

### Inventory

- Generated dynamically by Terraform, the inventory specifies the IP addresses of the master and worker nodes for Ansible.

## Getting Started

### Prerequisites

- AWS Account
- Terraform
- Ansible
- Kubernetes CLI (kubectl)

### Setup Infrastructure

1. **Provision EC2 Instances**:
Navigate to `terraform/` and execute:
    
    ```bash
    terraform init
    terraform apply
    
    ```
    
2. **Create EKS Cluster**:
Change to eks-terraform/ and run:
    
    ```bash
    terraform init
    terraform apply
    
    ```
    
3. **Deploy Application**:
    - **Build Docker Images**:
        
        ```bash
        cd docker/
        docker build -t your-application-image .
        
        ```
        
    - **Deploy with Kubernetes**:
    Apply the Kubernetes configurations in kube/:
        
        ```bash
        kubectl apply -f kube/
        
        ```
        
4. **Using Ansible for Automation**:
Run the Ansible playbook from the ansible/ directory:
    
    ```bash
    ansible-playbook -i hosts.ini setup.yml
    
    ```
    

## Contributing

We welcome contributions! Please fork the project, create a feature branch, and submit a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE.md](http://license.md/) file for details.

This README now reflects a more detailed and specific guide to setting up and managing your commenting application infrastructure, emphasizing Kubernetes best practices and configurations for high availability and performance.
