/* REQUIRED -------------------------------------*/

variable "cloudflare_token" {
  description = "Token for interacting with Cloudflare API."
  type        = string
}

variable "cloudflare_email" {
  description = "Email address of Cloudflare account."
  type        = string
}

variable "cloudflare_account" {
  description = "ID of CloudFlare Account."
  type        = string
}

variable "aws_access_key" {
  description = "Access key for the AWS API."
}

variable "aws_secret_key" {
  description = "Secret key for the AWS API."
}

variable "aws_zone" {
  description = "Name of the AWS Availability Zone."
  default     = "eu-central-1"
}

/* GENERAL --------------------------------------*/

variable "domain" {
  description = "DNS Domain to update"
  type        = string
  default     = "statusim.net"
}

/* This policy allow Serverless to create it's resources
 * It's a bit broad, but they are still under development. */
variable "serverless_iam_policy" {
  description = "AWS IAM Policy necessary for Serverless API access."
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "serverless_users" {
  description = "List of Serverless users for AWS API"
  type        = list(string)
  default     = [ "test-user" ]
}
