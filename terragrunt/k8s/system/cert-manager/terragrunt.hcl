include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../terraform/base-helm"
}

dependency "cni-flannel" {
  config_path  = "../cni-flannel"
  skip_outputs = true
}

inputs = {
  repository    = "https://charts.jetstack.io"
  chart         = "cert-manager"
  chart_version = "1.16.2"
  namespace     = "cert-manager"
  release_name  = "cert-manager"

  values = {
    crds = {
      enabled = true
    }
  }
}