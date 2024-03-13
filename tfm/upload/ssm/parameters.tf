resource "aws_ssm_parameter" "s3_upload_bucket_name_store" {
  name  = "s3_upload_bucket_name"
  type  = "String"
  value = var.s3_upload_bucket_name
}