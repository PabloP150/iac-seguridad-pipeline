terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }
}

# Nada de esto se despliega: el repo solo existe para que Checkov lo analice.
provider "aws" {
  region = var.region
}
