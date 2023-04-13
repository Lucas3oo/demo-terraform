terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
  backend "s3" {
    bucket = "slrk-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }

}
provider "aws" {
  region = "eu-north-1"
}


## Variables
variable "slrk_deploy_bucket" {
  description = "bucket name"
}
variable "slrk_deploy_owner" {
  description = "owner, e.g responsible team"
}
variable "slrk_deploy_access_token" {
  description = "AccessToken for a service."
  sensitive = true
}


data "external" "current_user" {
  program = ["external/current-user.sh"]
}

output "current_user" {
  value = data.external.current_user.result.user
}


module "s3bucket_module" {
  source = "./modules/s3bucket_module"
  bucket = var.slrk_deploy_bucket
  environment = terraform.workspace
  owner = var.slrk_deploy_owner
  updated_by = data.external.current_user.result.user
  access_token = rsadecrypt(var.slrk_deploy_access_token, file("keypair.pem"))
}

output "s3_bucket_arn" {
  value = "${module.s3bucket_module.arn}"
}
