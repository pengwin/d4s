locals {
  secret_name = "${var.name}-user"
}

resource "random_password" "password" {
  length  = 16
  special = true
}

resource "kubernetes_secret" "credentials" {
  metadata {
    name      = local.secret_name
    namespace = var.namespace
  }

  type = "kubernetes.io/basic-auth"

  data = {
    username = "${var.username}"
    password = random_password.password.result
  }
}

resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    spec = {
      instances = var.instances

      bootstrap = {
        initdb = {
          database = var.database
          owner    = var.username
          secret = {
            name = local.secret_name
          }
        }
      }

      storage = {
        storageClass = var.storage_class
        size         = var.size
      }
    }
  }

  wait {
    fields = {
      "status.phase" = "Cluster in healthy state"
      "status.readyInstances" = "${var.instances}"
    }
  }

  depends_on = [ kubernetes_secret.credentials ]
}
