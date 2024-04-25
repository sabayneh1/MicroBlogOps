output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}

# Since there's no direct output for cluster_token, this output needs to be handled differently.
# You may need to remove it or handle token retrieval outside of Terraform.
output "cluster_name" {
  value = var.cluster_name
}
