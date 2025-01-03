variable "kubeconfig_file_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "cluster_master_ip" {
  description = "The IP address of the Kubernetes master node"
  type        = string
}