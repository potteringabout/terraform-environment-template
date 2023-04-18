variable "tags" {
  type = object({
    project         = string
    account         = string
    owner           = string
    email           = string
  })
}

output "var1" {
  value = "value1"
}

output "tags" {
  value = var.tags
}