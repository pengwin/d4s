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
      // uncomment on future releases of metrics-server
      /*apiService = {
        insecureSkipTLSVerify = false
      }

      tls = {
        type = "cert-manager"
        certManager = {
          existingIssuer = {
            enabled = true
            kind    = "ClusterIssuer"
            name    = var.cluster_issuer_name
          }
        }
      }*/

      args = [
        "--kubelet-insecure-tls" # Required for self-signed certificates
      ]
    })
  ]
}
