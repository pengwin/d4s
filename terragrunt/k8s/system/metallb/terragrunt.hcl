include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}

dependency "cni-calico" {
  config_path  = find_in_parent_folders("cni-calico")
  skip_outputs = true
}

inputs = {
  repository    = "https://metallb.github.io/metallb/"
  chart         = "metallb"
  chart_version = "0.14.9"
  namespace     = "metallb-system"
  release_name  = "metallb"

  values = {}
}