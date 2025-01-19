locals {

}


resource "random_password" "grafana_admin_password" {
  length  = 16
  special = true
}

resource "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = var.admin_secret_name
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    username = var.username
    password = random_password.grafana_admin_password.result
  }
}

resource "kubernetes_manifest" "grafana" {
  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "Grafana"
    metadata = {
      name      = var.name
      namespace = var.namespace
      labels = {
        dashboards = var.name
      }
    }
    spec = {
      persistentVolumeClaim = {
        spec = {
          accessModes = ["ReadWriteOnce"]
          resources = {
            requests = {
              storage = var.size
            }
          }
          storageClassName = var.storage_class
        }
      }
      config = {
        log = {
          mode = "console"
        }
        auth = {
          disable_login_form = "false"
        }
        plugins = {
          allow_loading_unsigned_plugins = var.allow_loading_unsigned_plugins
        }
        /*security = {
          admin_user     = "root"
          admin_password = "secret"
        }*/
      }
      ingress = {
        metadata = {
          annotations = {
            "cert-manager.io/cluster-issuer" = var.cluster_issuer_name
          }
        }
        spec = {
          ingressClassName = "nginx"

          rules = [{
            host = var.hostname
            http = {
              paths = [{
                pathType = "Prefix"
                path     = "/"
                backend = {
                  service = {
                    name = "${var.name}-service"
                    port = {
                      number = 3000
                    }
                  }
                }
              }]
            }
          }]

          tls = [{
            hosts      = [var.hostname]
            secretName = "${var.name}-tls"
          }]
        }
      }
      deployment = {
        spec = {
          replicas = var.instances
          template = {
            spec = {
              initContainers = var.init_containers
              containers = [{
                name = "grafana"
                readinessProbe = {
                  failureThreshold = 3
                }
                env = [{
                  name = "GF_SECURITY_ADMIN_USER"
                  valueFrom = {
                    secretKeyRef = {
                      key  = "username"
                      name = var.admin_secret_name
                    }
                  }
                  }, {
                  name = "GF_SECURITY_ADMIN_PASSWORD"
                  valueFrom = {
                    secretKeyRef = {
                      key  = "password"
                      name = var.admin_secret_name
                    }
                  }
                }]
                securityContext = {
                  runAsNonRoot = true
                  runAsUser    = 472 #(nobody)
                  runAsGroup   = 472 #(nobody)
                }
              }]
              volumes = [{
                name = "grafana-data"
                persistentVolumeClaim = {
                  claimName = "${var.name}-pvc"
                }
              }]
            }
          }
        }
      }
    }
  }

  field_manager {
    force_conflicts = true
  }

}
