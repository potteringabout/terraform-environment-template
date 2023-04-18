locals {
  terraform = yamldecode(file("${get_parent_terragrunt_dir()}/terraform.yml"))
  inputs = try(yamldecode(file("${get_parent_terragrunt_dir()}/inputs.yml")), {})
  
  project = local.inputs.tags.project
  accountid = local.inputs.accountid
  account = local.inputs.tags.account
  component_path = split("/", path_relative_to_include())
  component_type = element(local.component_path, 0) 
  component = element(local.component_path, length(local.component_path)-1) 

  environment = local.component_type == "environment" ? local.inputs.tags.environment : ""
  
  state_key = local.component_type == "environment" ? "state/${local.project}/${local.account}/${local.environment}/${local.component}.tfstate" : "state/${local.project}/${local.account}/${local.component}.tfstate"

  deployment_role  = "arn:aws:iam::${local.accountid}:role/${local.project}-${local.account}-deployment"
  
}

inputs = merge(
  local.inputs
)

terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["tfswitch", "${local.terraform.version}"]
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

terraform {
  backend "s3" {
    bucket         = "potteringabout-build"
    key            = "${local.state_key}"
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
    role_arn = "${local.deployment_role}"
  }
}


EOF
}