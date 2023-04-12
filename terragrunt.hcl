locals {
  terraform_version = "1.4.3"
}

terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["tfswitch", "${local.terraform_version}"]
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "potteringabout-build"
    key            = "state/${local_inputs.tags.account}/${path_relative_to_include()}.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "tflocks"
  }
}
EOF
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::0123456789:role/terragrunt"
  }
}
EOF
}