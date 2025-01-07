include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../terraform/base-helm"
}

inputs = {
  repository    = "https://flannel-io.github.io/flannel/"
  chart         = "flannel"
  chart_version = "0.26.2"
  namespace     = "kube-flannel"
  release_name  = "flannel"

  values = {
    flannel = {
      backend = "host-gw"
    }
  }
}