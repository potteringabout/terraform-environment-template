locals {
  terraform_version = "1.4.4"
  local_inputs = read_terragrunt_config("${get_parent_terragrunt_dir()}/inputs.hcl", {inputs = {}})
}

inputs = merge(
  local.local_inputs.inputs
)

terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["tfswitch", "${local.terraform_version}"]
    #execute      = ["tfswitch", "1.4.4"]
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

terraform {
  backend "s3" {
    bucket         = "potteringabout-build"
    key            = "state/${local.local_inputs.inputs.tags.account}/${local.local_inputs.inputs.tags.environmenti}/${path_relative_to_include()}.tfstate"
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