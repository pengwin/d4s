locals {
  certs_release_name = "${var.release_name}-certs"

  #cert_name          = "docker-reg-cert"
  #issuer_name        = "docker-reg-issuer"
  #secret_name        = "docker-reg-cert"
  #common_name        = "docker-registry.local"
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

resource "tls_private_key" "ca_private_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca_private_key.private_key_pem

  is_ca_certificate = true

  subject {
    country             = "RS"
    province            = "Belgrade"
    locality            = "Belgrade"
    common_name         = "Test K8S CA"
    organization        = "Test K8S"
    organizational_unit = "Test K8S"
  }

  validity_period_hours = 24*365

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
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
        tls_crt = tls_self_signed_cert.ca_cert.cert_pem
        tls_key = tls_private_key.ca_private_key.private_key_pem
      }
    })
  ]

  depends_on = [helm_release.cert-manager]
}
