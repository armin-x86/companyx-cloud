terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key            = "vpc/app-euw-1/terraform.tfstate"
    bucket         = "phrase-infra-terraform-staging-8f402f"
    region         = "eu-west-1"
    dynamodb_table = "phrase-infra-terraform-staging-8f402f"
    encrypt        = true
  }
}
