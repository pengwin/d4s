include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

generate "main" {
  path      = "main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "kubernetes_namespace" "gitea" {
  metadata {
    name = var.name
  }
}
variable "name" {
  type = string
  description = "Name of the observability namespace"
}
EOF
}

inputs = {
  name = "observability"
}