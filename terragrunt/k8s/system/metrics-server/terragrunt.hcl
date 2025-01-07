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
  repository    = "https://kubernetes-sigs.github.io/metrics-server/"
  chart         = "metrics-server"
  chart_version = "3.12.2"
  namespace     = "metrics-server"
  release_name  = "metrics-server"

  values = {
    // uncomment on future releases of metrics-server
    /*apiService = {
        insecureSkipTLSVerify = false
      }

      tls = {
        type = "cert-manager"
        certManager = {
          existingIssuer = {
            enabled = true
            kind    = "ClusterIssuer"
            name    = var.cluster_issuer_name
          }
        }
      }*/

    args = [
      "--kubelet-insecure-tls" # Required for self-signed certificates
    ]
  }
}