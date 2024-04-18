output "oidc_provider" {
  value = aws_iam_openid_connect_provider.oidc_provider
}

output "eks_cluster" {
    value = module.eks.cluster_id
  
}