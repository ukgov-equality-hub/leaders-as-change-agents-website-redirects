
variable "service_name" {
  type = string
  description = "The short name of the service."
  default = "laca_website"
}

variable "service_name_hyphens" {
  type = string
  description = "The short name of the service (using hyphen-style)."
  default = "laca-website"
}

variable "aws_region" {
  type = string
  description = "The AWS region used for the provider and resources."
  default = "eu-west-2"
}

variable "prevent_email_spoofing" {
  type = bool
  description = "Should terraform create DNS records to prevent email spoofing (only required for the prod environment)"
  default = true
}
