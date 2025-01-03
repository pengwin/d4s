variable "cluster_master_ip" {
  description = "The IP address of the Kubernetes master node"
  type        = string
}

variable "cluster_worker_node" {
  description = "The IP address of the Kubernetes first worker node"
  type        = string
}

variable "ca_key_file_path" {
  description = "Path to the CA private key file"
  type        = string
}

variable "ca_cert_file_path" {
  description = "Path to the CA certificate file"
  type        = string
}

variable "kubeconfig_file_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "nfs_server" {
  description = "The IP address of the NFS server"
  type        = string
}
