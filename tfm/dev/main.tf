module "s3" {
    source = "../upload/s3"
    env = var.env

}


module "ssm" {
    source = "../upload/ssm"
    env = var.env
    s3_upload_bucket_name = module.s3.outputs.upload_bucket_name

}