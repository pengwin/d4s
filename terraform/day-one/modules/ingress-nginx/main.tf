resource "helm_release" "nginx_ingress" {
  name = var.release_name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          kind = "daemonset"
          type = "LoadBalancer"
          annotations = {
            "metallb.ip/allow-shared-ip" = "nginx"
          }
        }
      }
    })
  ]
}
