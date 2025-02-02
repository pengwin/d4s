include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}

dependency "gitea-ns" {
  config_path  = find_in_parent_folders("gitea-ns")
  skip_outputs = true
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

dependency "gitea-pg" {
  config_path = "../gitea-pg"

  mock_outputs = {
    password = "mocked"
  }
}

locals {
  gitea_admin_secret_name = "gitea-admin"
  admin_username          = "k8s_admin"
  admin_email             = "k8s_admin@${include.root.locals.env.gitea_domain}"
}

generate "gitea_admin_secret" {
  path      = "_gitea_admin_secret.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "random_password" "gitea_admin_password" {
  length  = 16
  override_special = "!@#%&*()-_=+[]<>:?"
  special = true
}

resource "kubernetes_secret" "gitea_admin" {
  metadata {
    name      = "${local.gitea_admin_secret_name}"
    namespace = "${dependency.gitea-ns.inputs.name}"
  }

  type = "Opaque"

  data = {
    username = "${local.admin_username}"
    password = random_password.gitea_admin_password.result
    email    = "${local.admin_email}"
  }
}
EOF
}

inputs = {
  repository       = "https://dl.gitea.com/charts/"
  chart            = "gitea"
  chart_version    = "10.6.0"
  namespace        = dependency.gitea-ns.inputs.name
  release_name     = "gitea"
  create_namespace = false

  values = {
    global = {
      storageClass = dependency.nfs-storage-class.inputs.storage_class_name
    }

    gitea = {
      admin = {
        existingSecret = local.gitea_admin_secret_name
        email          = local.admin_email
        passwordMode   = "keepUpdated"
      }
      config = {
        database = {
          DB_TYPE = "postgres"
          HOST    = "${dependency.gitea-pg.inputs.name}-rw:5432"
          NAME    = "${dependency.gitea-pg.inputs.database}"
          USER    = "${dependency.gitea-pg.inputs.username}"
          PASSWD  = "${dependency.gitea-pg.outputs.password}"
          SCHEMA  = "public"
        }
      }
      additionalConfigFromEnvs = [
        {
          name  = "GITEA__CACHE__ADAPTER"
          value = "memory"
        },
        {
          name  = "GITEA__CACHE__INTERVAL"
          value = "60"
        }
      ]
    }

    service = {
      ssh = {
        type = "LoadBalancer"
        annotations = {
          "metallb.io/allow-shared-ip" = include.root.locals.env.lb_shared_ip
        }
      }
    }

    ingress = {
      enabled   = true
      className = "nginx"

      annotations = {
        "cert-manager.io/cluster-issuer" = dependency.cert-issuer.inputs.cluster_issuer_name
      }

      hosts = [
        {
          host = include.root.locals.env.gitea_domain
          paths = [
            {
              path     = "/"
              pathType = "Prefix"
            }
          ]
        }
      ]

      tls = [
        {
          secretName = "gitea-tls"
          hosts = [
            include.root.locals.env.gitea_domain
          ]
        }
      ]
    }

    redis-cluster = {
      enabled = false
    }

    postgresql-ha = {
      enabled = false
    }

    redis = {
      enabled = false
    }

    postgresql = {
      enabled = false
    }
  }
}