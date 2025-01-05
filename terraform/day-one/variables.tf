variable "cluster_nodes" {
  description = "The map of nodes of cluster"
  type        = map(string)
}


variable "ca_key_file_pem" {
  description = "Content of the CA private key PEM"
  type        = string
  sensitive   = true
}

variable "ca_cert_file_pem" {
  description = "Content of the CA certificate PEM"
  type        = string
  sensitive   = true
}

variable "kubeconfig_file_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "nfs_server" {
  description = "The IP address of the NFS server"
  type        = string
}

variable "pi_hole_password" {
  description = "The password for the pi-hole web interface"
  type        = string
}
