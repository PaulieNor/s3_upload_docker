resource "aws_s3_bucket" "upload_bucket" {
  bucket = "${var.env}-s3-upload-bucket-22222"
}