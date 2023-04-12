include "root" {
  path = find_in_parent_folders()
}

dependency "component1" {
  config_path = "../component1"
}

locals {
  local_inputs = read_terragrunt_config("inputs.hcl", {inputs = {}})
}

inputs = merge(
  local.local_inputs.inputs,
  {
    var1   = dependency.component1.outputs.var1
  }
)