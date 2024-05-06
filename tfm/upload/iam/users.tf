resource "aws_iam_user" "github_actions_user" {
  name = "${var.env}-github-actions-user"
}

# Attach inline policy to the IAM user
resource "aws_iam_user_policy_attachment" "github_actions_policy_attachment" {
  user       = aws_iam_user.github_actions_user.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}