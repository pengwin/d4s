locals {
  secret_name = "docker-reg-cert"
  common_name = "docker-registry.test-kubernetes"
}

resource "helm_release" "docker-registry" {
  name = var.release_name

  repository = "https://helm.twun.io"
  chart      = "docker-registry"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      persistence = {
        enabled      = true
        size         = "2Gi"
        storageClass = var.storage_class_name
      }

      service = {
        type = "ClusterIP"
        port = 80
      }

      ingress = {
        enabled = true
        annotations = {
          "nginx.ingress.kubernetes.io/proxy-body-size" = "50m"
          "nginx.org/proxy-body-size"                   = "50m",
          "cert-manager.io/cluster-issuer"              = var.cluster_issuer_name
        }
        hosts = [
          local.common_name
        ]
        path = "/"
        tls = [
          {
            secretName = local.secret_name
            hosts = [
              local.common_name
            ]
          }
        ]
      }

    })
  ]
}


