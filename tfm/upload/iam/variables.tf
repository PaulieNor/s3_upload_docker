variable "account_id" {}

variable "s3_upload_bucket_name" {

}

variable "iam_policies" {
  type = list(object({
    name        = string
    policy_json = string
  }))
  default = [{
    ### Github actions policy for adding images to ECR ###
    name = "${var.env}_github_actions_upload"
    policy_json = jsondecode({
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
      },

    )
    },
    ### Read/write permissions for upload container. ###
    {
      name = "${var.env}_s3_upload"
      policy_json = jsondecode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "VisualEditor0",
            "Effect" : "Allow",
            "Action" : [
              "s3:PutObject",
              "s3:GetObject"
            ],
            "Resource" : [
              "arn:aws:s3:::arn:aws:s3:::${var.s3_upload_bucket_name}/*",
              "arn:aws:s3:::arn:aws:s3:::${var.s3_upload_bucket_name}/"
            ]
          }
        ]
      })

  }]


}