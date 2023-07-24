resource "aws_iam_user" "user" {
  name = var.user_name
  force_destroy = true
}

resource "aws_iam_user_group_membership" "developers" {
  groups = [
    aws_iam_group.developers.name
  ]
}

resource "aws_iam_user_login_profile" "login_profile" {
  user = aws_iam_user.user.name
  pgp_key = file("./cert/master.public.gpg") # gpgファイルは別途用意する
  password_length = 20
  password_reset_required = true
}

output "password" {
  value = aws_iam_user_login_profile.login_profile.encrypted_password
}