resource "aws_iam_user" "serverless_users" {
  name  = var.serverless_users[count.index]
  count = length(var.serverless_users)
  tags  = { Purpose = "Serverless API access" }
}

resource "aws_iam_group" "serverless_users" {
  name = "serverless-users"
  path = "/users/"
}

resource "aws_iam_access_key" "serverless_users" {
  user    = aws_iam_user.serverless_users[count.index].name
  count   = length(aws_iam_user.serverless_users)
  # GPG key for encrypting the secret key
  pgp_key = file("files/webiny@status.im.gpg")
}

resource "aws_iam_group_membership" "serverless_users" {
  name  = "serverless-group-membership"
  group = aws_iam_group.serverless_users.name
  users = aws_iam_user.serverless_users.*.name
}

resource "aws_iam_group_policy_attachment" "serverless_users" {
  group      = aws_iam_group.serverless_users.name
  policy_arn = var.serverless_iam_policy
}
