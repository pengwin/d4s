include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../terraform/grafana-instance"
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

dependency "grafana-operator" {
  config_path  = "../grafana-operator"
  skip_outputs = true
}

locals {
  grafana_admin_secret_name = "grafana-admin"
  admin_username            = "k8s_admin"
  victoria_logs_plugin_init = {
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

  allow_loading_unsigned_plugins = "victoriametrics-logs-datasource"
  init_containers                = [local.victoria_logs_plugin_init]
}


/*repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  chart_version    = "8.8.3"
  namespace        = "grafana"
  release_name     = "grafana"
  create_namespace = false

  values = {

    "grafana.ini" = {
      plugins = {
        allow_loading_unsigned_plugins = "victoriametrics-logs-datasource"
      }
      log = {
        mode  = "console"
        level = "debug"
      }
    }

    admin = {
      existingSecret = local.grafana_admin_secret_name
      userKey        = "username"
      passwordKey    = "password"
    }

    persistence = {
      enabled          = true
      storageClassName = dependency.nfs-storage-class.inputs.storage_class_name
      size             = "10Gi"
    }

    initChownData = {
      enabled = false
    }

    datasources = {
      "vm-logs.yml" = {
        apiVersion = 1
        datasources = [
          {
            # <string, required> Name of the VictoriaLogs datasource
            # displayed in Grafana panels and queries.
            name = "VictoriaLogs"
            # <string, required> Sets the data source type.
            type = "victoriametrics-logs-datasource"
            # <string, required> Sets the access mode, either
            # proxy or direct (Server or Browser in the UI).
            access = "proxy"
            # <string> Sets URL for sending queries to VictoriaLogs server.
            # see https://docs.victoriametrics.com/victorialogs/querying/
            url = "http://victoria-logs-victoria-logs-single-server.victoria-metrics.svc.cluster.local:9428"
            # <string> Sets the pre-selected datasource for new panels.
            # You can set only one default data source per organization.
            isDefault = true
          }
        ]
      }
    }

    extraInitContainers = [
      {
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
ver=v0.13.0
curl -L https://github.com/VictoriaMetrics/victorialogs-datasource/releases/download/$ver/victoriametrics-logs-datasource-$ver.tar.gz -o /var/lib/grafana/plugins/vl-plugin.tar.gz
tar -xf /var/lib/grafana/plugins/vl-plugin.tar.gz -C /var/lib/grafana/plugins/
rm /var/lib/grafana/plugins/vl-plugin.tar.gz
EOT
        ]
        volumeMounts = [
          {
            name      = "storage"
            mountPath = "/var/lib/grafana"
          }
        ]
      }
    ]

    sidecar = {
      datasources = {
        enabled         = true
        initDatasources = true
      }

    }


    securityContext = {
      runAsNonRoot = true
      runAsUser    = 472 #(nobody)
      runAsGroup   = 472 #(nobody)
      fsGroup      = 472 #(nobody)
    }


    ingress = {
      enabled          = true
      ingressClassName = "nginx"

      annotations = {
        "cert-manager.io/cluster-issuer" = dependency.cert-issuer.inputs.cluster_issuer_name
      }

      hosts = [include.root.locals.env.grafana_domain]

      tls = [
        {
          secretName = "grafana-tls"
          hosts = [
            include.root.locals.env.grafana_domain
          ]
        }
      ]
    }
  }
}*/