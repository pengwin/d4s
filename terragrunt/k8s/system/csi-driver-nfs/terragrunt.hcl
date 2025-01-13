include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../terraform/base-helm"
}

dependency "cni-calico" {
  config_path  = "../cni-calico"
  skip_outputs = true
}

inputs = {
  repository    = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart         = "csi-driver-nfs"
  chart_version = "4.9.0"
  namespace     = "kube-system"
  release_name  = "csi-driver-nfs"

  values = {
    controller = {
      service = {
        kind = "daemonset"
        type = "NodePort"
      }
    }

    feature = {
      enableFSGroupPolicy = false
    }
  }
}