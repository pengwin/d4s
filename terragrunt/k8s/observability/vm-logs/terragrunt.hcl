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

inputs = {
  repository       = "https://victoriametrics.github.io/helm-charts/"
  chart            = "victoria-logs-single"
  chart_version    = "0.8.13"
  namespace        = "victoria-metrics"
  release_name     = "victoria-logs"
  create_namespace = true

  values = {
    vector = {
      enabled = true
    }
    server = {
      persistentVolume = {
        enabled          = true
        storageClassName = dependency.nfs-storage-class.inputs.storage_class_name
      }

      retentionPeriod         = "1d"
      retentionDiskSpaceUsage = "1GiB"

      ingress = {
        enabled          = true
        ingressClassName = "nginx"
        annotations = {
          "cert-manager.io/cluster-issuer" = dependency.cert-issuer.inputs.cluster_issuer_name
        }

        hosts = [
          {
            name = include.root.locals.env.victoria_logs_domain
            path = ["/"]
            port = "http"
          }
        ]

        tls = [
          {
            secretName = "victoria-logs-tls"
            hosts = [
              include.root.locals.env.victoria_logs_domain
            ]
          }
        ]
      }
    }
  }
}