data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_policy" "assume_role" {
  name   = "AssumeRolePolicy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRoleWithWebIdentity",
      Resource  = "*",
      Condition = {
        "StringEquals": {
          "${var.oidc_provider.url}:sub": "system:serviceaccount:s3-upload:s3-upload-sa"
        }
      }
    }]
  })
}


resource "aws_eks_pod_identity_association" "eks_policy_association" {
  cluster_name    = var.eks_cluster
  namespace       = "upload-app"
  service_account = "upload-sa"
  role_arn        = aws_iam_role.s3_upload_role.id
}


data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}


resource "aws_iam_role" "s3_upload_role" {
  name               = "${var.env}-eks-pod-upload-role"
  assume_role_policy = aws_iam_policy.assume_role.policy
}

resource "aws_iam_role_policy_attachment" "s3_policy_role_attachment" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.s3_upload_role.id
}