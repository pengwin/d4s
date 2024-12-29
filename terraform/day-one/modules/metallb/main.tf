locals {
  config_release_name = "${var.release_name}-config"
  ip_pool_name        = "nodes_pool"
}

resource "helm_release" "metallb" {
  name = var.release_name

  repository = "https://metallb.github.io/metallb/"
  chart      = "metallb"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({

    })
  ]
}

resource "helm_release" "metallb_config" {
  name = local.config_release_name

  chart = "${path.module}/chart"

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      cluster_issuer_name = local.ip_pool_name
      cluster_master_ip   = "${var.cluster_master_ip}/32"
    })
  ]

  depends_on = [helm_release.metallb]
}

