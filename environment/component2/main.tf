variable "tags" {
  type = object({
    project         = string
    account         = string
    environment     = string
    owner           = string
    email           = string
  })
}

variable "var1" {}

output "tags" {
  value = var.tags
}


