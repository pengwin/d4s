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

dependency "cert-issuer" {
  config_path  = "../../system/cert-issuer"
  skip_outputs = true
}

dependency "ingress-nginx" {
  config_path  = "../../system/ingress-nginx"
  skip_outputs = true
}

dependency "ns" {
  config_path  = "../observability-namespace"
  skip_outputs = true
}

inputs = {
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana-operator"
  chart_version    = "v5.16.0"
  namespace        = dependency.ns.inputs.name
  release_name     = "grafana-operator"
  create_namespace = false

  values = {
  }
}