

resource "aws_iam_policy" "ecr_policy" {
  name   = "${var.env}-ECRAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Terraform"
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "${var.ecr_repo_arn}"
      },
      {
        Sid      = "VisualEditor1"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_policy" "s3_policy" {
  name   = "${var.env}-S3AccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid     = "Terraform",
        Effect  = "Allow",
        Action  = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_upload_bucket_name}/*",
          "arn:aws:s3:::${var.s3_upload_bucket_name}/"
        ]
      }
    ]
  })
}

