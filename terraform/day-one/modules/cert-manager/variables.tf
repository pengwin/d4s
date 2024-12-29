variable "chart_version" {
  description = "The version of the cert-manager chart to install"
  type        = string
  default = "1.16.2"
}

variable "namespace" {
  description = "The namespace to install the cert-manager controller into"
  type        = string
  default     = "cert-manager"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "cert-manager"
}

variable "cluster_issuer_name" {
  description = "The name of the cluster issuer"
  type        = string
  default     = "selfsigned-cluster-issuer"
}

variable "ca_key_file_path" {
  description = "Path to the CA private key file"
  type        = string
}

variable "ca_cert_file_path" {
  description = "Path to the CA certificate file"
  type        = string
}