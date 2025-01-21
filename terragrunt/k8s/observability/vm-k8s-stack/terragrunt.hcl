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

dependency "vm-operator" {
  config_path  = find_in_parent_folders("vm-operator")
  skip_outputs = true
}

dependency "grafana-operator" {
  config_path  = find_in_parent_folders("grafana-operator")
  skip_outputs = true
}

locals {
  release_name = "victoria-metrics-k8s-stack"
}

generate "datasource" {
  path      = "_grafana-datasource.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    resource "kubernetes_manifest" "grafana_datasource_victoriametrics" {
      manifest = {
        apiVersion = "grafana.integreatly.org/v1beta1"
        kind       = "GrafanaDatasource"
        metadata = {
          name      = "victoriametrics"
          namespace = "${dependency.ns.inputs.name}"
        }
        spec = {
          instanceSelector = {
            matchLabels = {
              dashboards = "grafana"
            }
          }
          datasource = {
            name      = "VictoriaMetrics"
            type      = "prometheus"
            access    = "proxy"
            isDefault = true

            url = "http://vmsingle-${local.release_name}:8429"
          }
        }
      }
    }

    resource "kubernetes_manifest" "grafana_datasource_victoriametrics_ds" {
      manifest = {
        apiVersion = "grafana.integreatly.org/v1beta1"
        kind       = "GrafanaDatasource"
        metadata = {
          name      = "victoriametrics-ds"
          namespace = "${dependency.ns.inputs.name}"
        }
        spec = {
          instanceSelector = {
            matchLabels = {
              dashboards = "grafana"
            }
          }
          datasource = {
            name   = "VictoriaMetrics (DS)"
            type   = "victoriametrics-datasource"
            access = "proxy"

            url = "http://vmsingle-${local.release_name}:8429"
          }
        }
      }
    }
    EOF
}

inputs = {
  repository       = "https://victoriametrics.github.io/helm-charts/"
  chart            = "victoria-metrics-k8s-stack"
  chart_version    = "0.33.5"
  namespace        = dependency.ns.inputs.name
  release_name     = local.release_name
  create_namespace = false

  values = {
    defaultDashboards = {
      enabled = true
      grafanaOperator = {
        enabled = true
      }
    }

    grafana = {
      enabled = false
    }

    victoria-metrics-operator = {
      enabled = false
    }

    vmsingle = {
      spec = {
        retentionPeriod         = "1d"
        retentionDiskSpaceUsage = "1GiB"
        storage = {
          storageClassName = dependency.nfs-storage-class.inputs.storage_class_name
        }
      }
    }
  }
}