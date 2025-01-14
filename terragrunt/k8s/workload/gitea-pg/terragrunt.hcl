include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../terraform/postgres-cluster"
}


dependency "nfs-storage-class" {
  config_path  = "../../system/nfs-storage-class"
  skip_outputs = true
}

dependency "postgres-operator" {
  config_path  = "../../db/cnpg-postgres-operator"
  skip_outputs = true
}

locals {
  namespace = "gitea"
}

generate "gitea_namespace" {
  path      = "_gitea_namespace.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "kubernetes_namespace" "gitea" {
  metadata {
    name = "${local.namespace}"
  }
}
EOF
}

inputs = {
  name          = "gitea-pg"
  namespace     = local.namespace
  instances     = 1
  storage_class = dependency.nfs-storage-class.inputs.storage_class_name
  size          = "1Gi"

  username = "gitea"
  database = "gitea"
}