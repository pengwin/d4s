variable "chart_version" {
  description = "The version of the metrics-server chart to install"
  type        = string
  default     = "3.12.2"
}

variable "namespace" {
  description = "The namespace to install the metrics-server controller into"
  type        = string
  default     = "metrics-server"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "metrics-server"
}

variable "cluster_issuer_name" {
  description = "The name of the cluster issuer"
  type        = string
}
