locals {
  certs_release_name = "${var.release_name}-certs"
}

resource "helm_release" "cert-manager" {
  name = var.release_name

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      crds = {
        enabled = true
      }
    })
  ]
}

resource "helm_release" "cert-issuers" {
  name = local.certs_release_name

  chart = "${path.module}/chart"

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      cluster_issuer_name = var.cluster_issuer_name
      ca_secret_name      = "ca-cert"

      ca_cert = {
        tls_crt = var.ca_cert_file_pem
        tls_key = var.ca_key_file_pem
      }
    })
  ]

  depends_on = [helm_release.cert-manager]
}
