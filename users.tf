resource "aws_iam_user" "serverless_test" {
  name = "serverless_test"
  tags = { Purpose = "Serverless API access" }
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.serverless_test.name
  policy_arn = var.serverless_iam_policy
}

resource "aws_iam_access_key" "serverless_test" {
  user    = aws_iam_user.serverless_test.name
  # GPG key for encrypting the secret key
  pgp_key = file("files/webiny@status.im.gpg")
}
