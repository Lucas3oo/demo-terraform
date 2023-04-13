variable "bucket" {
  description = "bucket name"
}

variable "environment" {
  description = "environment name, eg. stage14"
}

variable "owner" {
  description = "owner, e.g responsible team"
  default = "solrike"
}

variable "updated_by" {
  description = "The user that modified the bucket."
}

variable "access_token" {
  description = "AccessToken for a service."
  sensitive = true
}

