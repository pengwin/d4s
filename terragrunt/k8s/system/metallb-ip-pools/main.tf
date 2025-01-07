variable "address_pool_name" {
  description = "The name of the address pool"
  type        = string
}

variable "namespace" {
  description = "The namespace to install the address pool into"
  type        = string
}

variable "ips" {
  description = "The list of IP addresses to add to the pool"
  type        = list(string)
}

locals {
  ips = [for ip in var.ips : "${ip}/32"]
}

resource "kubernetes_manifest" "address_pool" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = var.address_pool_name
      namespace = var.namespace
    }

    spec = {
      addresses = local.ips
    }
  }
}

/*resource "kubernetes_manifest" "advertisement" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata = {
      name      = "${var.address_pool_name}-advertisement"
      namespace = var.namespace
    }
    spec = {
      ipAddressPools = [
        var.address_pool_name
      ]
    }
  }
  depends_on = [kubernetes_manifest.address_pool]
}*/
