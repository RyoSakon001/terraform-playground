resource "aws_iam_policy" "billing_deny" {
  name = "${var.project}-${var.environment}-billing-deny-iam-policy"
  description = "Deny billing access"
  policy = data.aws_iam_policy_document.billing_deny.json
}

data "aws_iam_policy_document" "billing_deny" {
  statement {
    effect = "Deny"
    actions = [
      "aws-portal:*"
    ]
    resources = [
      "*"
    ]
  }
}