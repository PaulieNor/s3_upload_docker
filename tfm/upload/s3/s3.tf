resource "aws_s3_bucket" "upload_bucket" {
  bucket = "${var.env}_s3_upload_bucket_22222"
}