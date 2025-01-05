resource "helm_release" "csi-driver-nfs" {
  name = var.release_name

  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart      = "csi-driver-nfs"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          kind = "daemonset"
          type = "NodePort"
        }
      }

      feature = {
        enableFSGroupPolicy = false
      }
    })
  ]
}

resource "kubernetes_storage_class" "nfs" {
  metadata {
    name = var.storage_class_name
  }

  parameters = {
    server           = var.nfs_server.server
    share            = var.nfs_server.share
    mountPermissions = "0777"
  }

  storage_provisioner = "nfs.csi.k8s.io"

  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true

  depends_on = [
    helm_release.csi-driver-nfs
  ]
}
