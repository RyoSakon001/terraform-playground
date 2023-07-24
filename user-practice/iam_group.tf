resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group_policy_attachment" "developers_billing_deny" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.billing_deny.arn
}

