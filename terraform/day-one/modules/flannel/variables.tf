variable "chart_version" {
  description = "The version of the flannel chart to install"
  type        = string
  default     = "0.26.2"
}

variable "namespace" {
  description = "The namespace to install the flannel controller into"
  type        = string
  default     = "kube-flannel"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "flannel"
}

variable "backend" {
  description = "The backend to use for flannel"
  type        = string
  default     = "host-gw"
}
