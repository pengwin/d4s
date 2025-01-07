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

locals {
  namespace               = "gitea"
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
  special = true
}

resource "kubernetes_namespace" "gitea" {
  metadata {
    name = "${local.namespace}"
  }
}

resource "kubernetes_secret" "gitea_admin" {
  metadata {
    name      = "${local.gitea_admin_secret_name}"
    namespace = "${local.namespace}"
  }

  type = "Opaque"

  data = {
    username = "${local.admin_username}"
    password = random_password.gitea_admin_password.result
    email    = "${local.admin_email}"
  }

  depends_on = [kubernetes_namespace.gitea]
}

output "gitea_admin_username" {
  value = "${local.admin_username}"
  sensitive = true
}

output "gitea_admin_password" {
  value = random_password.gitea_admin_password.result
  sensitive = true
}
EOF
}

inputs = {
  repository       = "https://dl.gitea.com/charts/"
  chart            = "gitea"
  chart_version    = "10.6.0"
  namespace        = local.namespace
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
      enabled = true
    }

    postgresql = {
      enabled = true
    }
  }
}