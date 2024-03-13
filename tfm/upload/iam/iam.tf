resource "aws_iam_policy" "github_actions_upload_policy" {
  name = "github_actions_upload_policy"
  path = "/"
  policy = jsondecode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"    = "VisualEditor0",
        "Effect" = "Allow",
        "Action" = [
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
        ],
        "Resource" = "arn:aws:ecr:*:${var.account_id}:repository/*"
      },
      {
        "Sid"      = "VisualEditor1",
        "Effect"   = "Allow",
        "Action"   = "ecr:GetAuthorizationToken",
        "Resource" = "*"
      }
    ]
    }
  )

}

