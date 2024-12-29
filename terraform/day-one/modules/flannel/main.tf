resource "helm_release" "flannel" {
  name = var.release_name

  repository = "https://flannel-io.github.io/flannel/"
  chart      = "flannel"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      flannel = {
        backend = var.backend
      }
    })
  ]
}
