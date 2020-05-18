resource "aws_iam_user" "serverless_test" {
  name = "serverless_test"
  tags = { Purpose = "Serverless API access" }
}

/* This policy allow Serverless to create it's resources
 * It's a bit broad, but they are still under development. */
resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = "${aws_iam_user.serverless_test.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "serverless_test" {
  user    = "${aws_iam_user.serverless_test.name}"
  # GPG key for encrypting the secret key
  pgp_key = file("files/webiny@status.im.gpg")
}
