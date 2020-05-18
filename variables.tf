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
