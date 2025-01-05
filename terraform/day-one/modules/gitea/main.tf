resource "random_password" "gitea_admin_password" {
  length  = 16
  special = true
}

resource "kubernetes_namespace" "gitea" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "gitea_admin" {
  metadata {
    name      = var.gitea_admin_secret_name
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    username = "k8s_admin"
    password = random_password.gitea_admin_password.result
    email    = base64encode("k8s_admin@${var.gitea_domain}")
  }

  depends_on = [kubernetes_namespace.gitea]
}

resource "helm_release" "gitea" {
  name = var.release_name

  repository = "https://dl.gitea.com/charts/"
  chart      = "gitea"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60 * 5
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({

      global = {
        storageClass = var.storage_class_name
      }

      gitea = {
        admin = {
          existingSecret = var.gitea_admin_secret_name
          email          = "k8s_admin@${var.gitea_domain}"
          passwordMode   = "keepUpdated"
        }
      }

      service = {
        ssh = {
          type = "LoadBalancer"
          annotations = {
            "metallb.io/allow-shared-ip" = "nginx"
          }
        }
      }

      ingress = {
        enabled   = true
        className = "nginx"

        annotations = {
          "cert-manager.io/cluster-issuer" = var.cluster_issuer_name
        }

        hosts = [
          {
            host = var.gitea_domain
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
              var.gitea_domain
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
    })
  ]

  depends_on = [kubernetes_secret.gitea_admin]
}
