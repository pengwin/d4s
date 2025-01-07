terraform {
  source = "."
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "argo-cd" {
  config_path = "../argo-cd"

  skip_outputs = true
}

generate "_main.tf" {
  path      = "_main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "kubernetes_secret" "argo_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "${dependency.argo-cd.inputs.namespace}"
  }
}

output "argocd_username" {
  value = "admin"
  sensitive = true
}

output "argocd_password" {
  value     = data.kubernetes_secret.argo_secret.data["password"]
  sensitive = true
}  
EOF
}

inputs = {

}