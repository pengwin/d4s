variable "storage_class_name" {
  description = "The name of the storage class"
  type        = string
}

variable "nfs_server" {
  description = "The NFS server configuration"
  type = object({
    server = string
    share  = string
  })
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
}
