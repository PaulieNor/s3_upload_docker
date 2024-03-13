resource "aws_ecr_repository" "s3-upload-ecr-repo" {
  name                 = "${var.env}-s3-upload"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}