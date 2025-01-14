include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../terraform/base-helm"
}

dependency "nfs-storage-class" {
  config_path  = "../../system/nfs-storage-class"
  skip_outputs = true
}

inputs = {
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  chart_version    = "0.23.0"
  namespace        = "cnpg-system"
  release_name     = "cloudnative-pg"
  create_namespace = true

  values = {

  }
}