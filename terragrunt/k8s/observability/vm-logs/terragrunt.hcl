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

dependency "grafana-operator" {
  config_path  = find_in_parent_folders("grafana-operator")
  skip_outputs = true
}

locals {
  chart        = "victoria-logs-single"
  release_name = "victoria-logs"
}

generate "dashboard" {
  path      = "_grafana-dashboard.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    resource "kubernetes_manifest" "grafana_dashboard_victorialogs" {
      manifest = {
        apiVersion = "grafana.integreatly.org/v1beta1"
        kind       = "GrafanaDashboard"
        metadata = {
          name      = "victorialogs"
          namespace = "${dependency.ns.inputs.name}"
        }
        spec = {
          instanceSelector = {
            matchLabels = {
              dashboards = "grafana"
            }
          }
          json = file("$${path.module}/dashboard.json")
        }
      }
    }
    EOF
}

generate "datasource" {
  path      = "_grafana-datasource.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    resource "kubernetes_manifest" "grafana_datasource_victorialogs" {
      manifest = {
        apiVersion = "grafana.integreatly.org/v1beta1"
        kind       = "GrafanaDatasource"
        metadata = {
          name      = "victorialogs"
          namespace = "${dependency.ns.inputs.name}"
        }
        spec = {
          instanceSelector = {
            matchLabels = {
              dashboards = "grafana"
            }
          }
          datasource = {
            name   = "VictoriaLogs"
            type   = "victoriametrics-logs-datasource"
            access = "proxy"
            url    = "http://${local.release_name}-${local.chart}-server:9428"
          }
        }
      }
    }
    EOF
}

inputs = {
  repository       = "https://victoriametrics.github.io/helm-charts/"
  chart            = local.chart
  chart_version    = "0.8.13"
  namespace        = dependency.ns.inputs.name
  release_name     = local.release_name
  create_namespace = false

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
        enabled = false
      }
    }
  }
}