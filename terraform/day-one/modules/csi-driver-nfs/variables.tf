variable "chart_version" {
  description = "The version of the csi-driver-nfs chart to install"
  type        = string
  default     = "4.9.0"
}

variable "namespace" {
  description = "The namespace to install the csi-driver-nfs controller into"
  type        = string
  default     = "kube-system"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "csi-driver-nfs"
}

variable "storage_class_name" {
  description = "The name of the storage class to create"
  type        = string
  default     = "nfs-storage-class"
}

variable "nfs_server" {
  description = "The IP address of the NFS server"
  type = object({
    server = string
    share  = string
  })
}
