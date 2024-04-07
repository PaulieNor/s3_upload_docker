resource "aws_iam_policy" "iam_policies" {
  for_each = var.iam_policies.value
  name = "${var.each.name}_policy"
  path = "/"
  policy = var.each.policy_json

}

