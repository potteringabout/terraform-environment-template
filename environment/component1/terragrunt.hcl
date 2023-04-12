include "root" {
  path = find_in_parent_folders()
}

locals {
  local_inputs = read_terragrunt_config("inputs.hcl", {inputs = {}})
}

inputs = merge(
  local.local_inputs.inputs
)
