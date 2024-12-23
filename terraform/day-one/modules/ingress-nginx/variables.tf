variable "chart_version" {
  description = "The version of the ingress-nginx chart to install"
  type        = string
  default = "4.11.3"
}

variable "namespace" {
  description = "The namespace to install the ingress-nginx controller into"
  type        = string
  default     = "ingress-nginx"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "ingress-nginx"
}