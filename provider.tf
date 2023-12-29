terraform {
   required_version = "~> 0.13"
   backend "s3" {
   region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
  version = "= 4.65.0"
  assume_role {
    role_arn = "arn:aws:iam::${var.account_number}:role/${var.department}-jenkins-assumed-role-${var.environment}"
  }

}
