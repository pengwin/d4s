include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}


dependency "nfs-storage-class" {
  config_path  = find_in_parent_folders("system/nfs-storage-class")
  skip_outputs = true
}

dependency "cert-issuer" {
  config_path  = find_in_parent_folders("system/cert-issuer")
  skip_outputs = true
}

dependency "ingress-nginx" {
  config_path  = find_in_parent_folders("system/ingress-nginx")
  skip_outputs = true
}

dependency "ns" {
  config_path  = find_in_parent_folders("observability-namespace")
  skip_outputs = true
}

inputs = {
  repository       = "https://victoriametrics.github.io/helm-charts/"
  chart            = "victoria-metrics-operator"
  chart_version    = "0.40.4"
  namespace        = dependency.ns.inputs.name
  release_name     = "victoria-metrics-operator"
  create_namespace = false

  values = {
    admissionWebhooks = {
      enabled = false
    }

    vmsingle = {
      spec = {
        storage = {
          storageClassName = dependency.nfs-storage-class.inputs.storage_class_name
        }
      }
    }
  }
}