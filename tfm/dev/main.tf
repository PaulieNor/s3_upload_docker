module "s3" {
  source = "../upload/s3"
  env    = var.env

}

module "ecr" {
  source = "../upload/ecr"
  env    = var.env

}

module "eks" {
  source        = "../upload/eks"
  env           = var.env
  min_size      = 2
  max_size      = 2
  instance_type = "t3.micro"
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.subnet_ids


}

module "network" {
  source                = "../upload/network"
    env           = var.env
  region                = var.aws_region
  public_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
  
}

module "ssm" {
  source                = "../upload/ssm"
  env                   = var.env
  s3_upload_bucket_name = module.s3.upload_bucket_name

}

module "iam" {
  source                = "../upload/iam"
  env                   = var.env
  s3_upload_bucket_name = module.s3.upload_bucket_name
  account_id = var.account_id
  oidc_provider = module.eks.oidc_provider
  eks_cluster = module.eks.eks_cluster
  ecr_repo_arn = module.ecr.ecr_repo_arn

}