module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = [var.public_subnet_cidr]

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {

    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = var.env
  }
}


resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list = [module.eks.aws_eks_cluster["eks-cluster"].identities[0].oidc[0].client_id]
  thumbprint_list = [module.eks.aws_eks_cluster["eks-cluster"].identities[0].oidc[0].thumbprint]
  url             = module.eks.aws_eks_cluster["eks-cluster"].identities[0].oidc[0].issuer
}