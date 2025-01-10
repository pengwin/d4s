variable "chart_version" {
  description = "The version of the external-dns chart to install"
  type        = string
  default     = "1.15.0"
}

variable "namespace" {
  description = "The namespace to install the external-dns controller into"
  type        = string
  default     = "external-dns"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "external-dns"
}
