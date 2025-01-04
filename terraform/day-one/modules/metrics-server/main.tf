resource "helm_release" "metrics-server" {
  name = var.release_name

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60 * 3
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      #apiService = {
      #  insecureSkipTLSVerify = false
      #}

      #tls = {
      #  type = "helm"
      #}

      args = [
        "--kubelet-insecure-tls"
      ]
    })
  ]
}
