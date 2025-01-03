variable "chart_version" {
  description = "The version of the metallb chart to install"
  type        = string
  default     = "0.14.9"
}

variable "namespace" {
  description = "The namespace to install the metallb into"
  type        = string
  default     = "metallb-system"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "metallb"
}

variable "cluster_master_ip" {
  description = "The IP address of the Kubernetes master node"
  type        = string
}

variable "cluster_worker_node" {
  description = "The IP address of the Kubernetes first worker node"
  type        = string
}
