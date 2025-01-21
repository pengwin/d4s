include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/grafana-instance")
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

dependency "grafana-operator" {
  config_path  = find_in_parent_folders("grafana-operator")
  skip_outputs = true
}

locals {
  grafana_admin_secret_name = "grafana-admin"
  admin_username            = "k8s_admin"
  victoria_logs_plugin_init = {
    name       = "load-vl-ds-plugin"
    image      = "curlimages/curl:7.85.0"
    command    = ["/bin/sh"]
    workingDir = "/var/lib/grafana"
    securityContext = {
      runAsUser    = 472
      runAsNonRoot = true
      runAsGroup   = 472
    }
    args = [
      "-c",
      <<-EOT
set -ex
mkdir -p /var/lib/grafana/plugins/
ver=v0.13.0
curl -L https://github.com/VictoriaMetrics/victorialogs-datasource/releases/download/$ver/victoriametrics-logs-datasource-$ver.tar.gz -o /var/lib/grafana/plugins/vl-plugin.tar.gz
tar -xf /var/lib/grafana/plugins/vl-plugin.tar.gz -C /var/lib/grafana/plugins/
rm /var/lib/grafana/plugins/vl-plugin.tar.gz
EOT
    ]
    volumeMounts = [
      {
        name      = "grafana-data"
        mountPath = "/var/lib/grafana"
      }
    ]
  }

  victoria_metrics_plugin_init = {
    name       = "load-vm-ds-plugin"
    image      = "curlimages/curl:7.85.0"
    command    = ["/bin/sh"]
    workingDir = "/var/lib/grafana"
    securityContext = {
      runAsUser    = 472
      runAsNonRoot = true
      runAsGroup   = 472
    }
    args = [
      "-c",
      <<-EOT
set -ex
mkdir -p /var/lib/grafana/plugins/
ver=v0.11.0
curl -L https://github.com/VictoriaMetrics/victoriametrics-datasource/releases/download/$ver/victoriametrics-datasource-$ver.tar.gz -o /var/lib/grafana/plugins/vm-plugin.tar.gz
tar -xf /var/lib/grafana/plugins/vm-plugin.tar.gz -C /var/lib/grafana/plugins/
rm /var/lib/grafana/plugins/vm-plugin.tar.gz
EOT
    ]
    volumeMounts = [
      {
        name      = "grafana-data"
        mountPath = "/var/lib/grafana"
      }
    ]
  }
}

inputs = {
  name                = "grafana"
  namespace           = dependency.grafana-operator.inputs.namespace
  instances           = 1
  storage_class       = dependency.nfs-storage-class.inputs.storage_class_name
  size                = "10Gi"
  admin_secret_name   = local.grafana_admin_secret_name
  username            = local.admin_username
  hostname            = include.root.locals.env.grafana_domain
  cluster_issuer_name = dependency.cert-issuer.inputs.cluster_issuer_name

  allow_loading_unsigned_plugins = "victoriametrics-logs-datasource,victoriametrics-datasource"
  init_containers                = [local.victoria_logs_plugin_init, local.victoria_metrics_plugin_init]
}