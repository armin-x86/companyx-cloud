terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key          = "alb/app-euw-1/terraform.tfstate"
    bucket       = "phrase-infra-terraform-staging-8f403v"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
