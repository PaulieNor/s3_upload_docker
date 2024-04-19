output "oidc_provider" {
  value = module.eks.oidc_provider
}

output "eks_cluster" {
    value = module.eks.cluster_id
  
}