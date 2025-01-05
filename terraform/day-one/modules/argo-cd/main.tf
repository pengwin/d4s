resource "helm_release" "argo-cd" {
  name = var.release_name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60 * 3
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      global = {
        domain = var.argo_domain
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }

      server = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
            "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
            "cert-manager.io/cluster-issuer"                 = var.cluster_issuer_name
          }

          tls = true
        }
      }
    })
  ]
}
