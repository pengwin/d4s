variable "namespace" {
  description = "The namespace for ca secret"
  type        = string
}

variable "ca_secret_name" {
  description = "The name of the secret to store the CA certificate"
  type        = string
}

variable "cluster_issuer_name" {
  description = "The name of the cluster issuer"
  type        = string
}

variable "ca_cert" {
  description = "The CA certificate"
  type = object({
    tls_crt = string
    tls_key = string
  })
}

resource "kubernetes_secret_v1" "ca_secret" {
  metadata {
    name      = var.ca_secret_name
    namespace = var.namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = var.ca_cert.tls_crt
    "tls.key" = var.ca_cert.tls_key
  }
}

resource "kubernetes_manifest" "issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.cluster_issuer_name
    }
    spec = {
      ca = {
        secretName      = var.ca_secret_name
      }
    }
  }

  depends_on = [kubernetes_secret_v1.ca_secret]
}
