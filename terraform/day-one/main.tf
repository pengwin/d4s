module "ingress_nginx" {
  source = "./modules/ingress-nginx"

  namespace = "ingress-nginx"
  chart_version = "4.11.3"
  release_name = "ingress-nginx"
}

module "csi-driver-nfs" {
  source = "./modules/csi-driver-nfs"

  namespace = "csi-driver-nfs"
  chart_version = "4.9.0"
  release_name = "csi-driver-nfs"
}

resource "kubernetes_storage_class" "nfs" {
  metadata {
    name = "nfs-storage-class"
  }

  parameters = {
    server   = "192.168.121.1"
    path     = "/srv/nfs/k8s_csi"
    readonly = "false"
  }

  storage_provisioner = "nfs.csi.k8s.io"

  reclaim_policy = "Delete"
  volume_binding_mode = "Immediate"
  allow_volume_expansion = true

  depends_on = [
    module.csi-driver-nfs
  ]
}
