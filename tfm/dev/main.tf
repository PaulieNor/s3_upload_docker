module "s3" {
  source = "../upload/s3"
  env    = var.env

}


module "eks" {
  source        = "../upload/eks"
  env           = var.env
  min_size      = 2
  max_size      = 2
  instance_type = "t3.micro"
  vpc_id = module.network.outputs.vpc_id


}

module "network" {
  source                = "../upload/network"
  
}

module "ssm" {
  source                = "../upload/ssm"
  env                   = var.env
  s3_upload_bucket_name = module.s3.outputs.upload_bucket_name

}