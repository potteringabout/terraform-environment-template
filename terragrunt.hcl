locals {
  terraform_version = yamldecode(file("${get_parent_terragrunt_dir()}/tfversion.yml"))
  inputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/inputs.yml")), {})
}

inputs = merge(
  local.inputs
)

terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["tfswitch", "${local.terraform_version.version}"]
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

terraform {
  backend "s3" {
    bucket         = "potteringabout-build"
    key            = "state/${local.inputs.tags.account}/${local.inputs.tags.environment}/${path_relative_to_include()}.tfstate"
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

%{ if local.inputs.account != "dev" }
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.account}:role/terragrunt"
  }
}
%{ endfor }


EOF
}