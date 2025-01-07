resource "helm_release" "chart" {
  name = var.release_name

  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = var.create_namespace

  timeout         = var.timeout
  atomic          = var.atomic
  cleanup_on_fail = var.cleanup_on_fail

  values = [
    yamlencode(var.values)
  ]
}
