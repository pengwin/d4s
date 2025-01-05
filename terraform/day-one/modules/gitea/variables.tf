variable "chart_version" {
  description = "The version of the gitea chart to install"
  type        = string
  default     = "10.6.0"
}

variable "namespace" {
  description = "The namespace to install the gitea into"
  type        = string
  default     = "gitea"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "gitea"
}

variable "gitea_domain" {
  description = "The DNS name for the Gitea server"
  type        = string
  default     = "gitea.test-kubernetes"
}

variable "storage_class_name" {
  description = "The name of the storage class"
  type        = string
}

variable "gitea_admin_secret_name" {
  description = "The name of the secret containing the Gitea admin credentials"
  type        = string
}

variable "cluster_issuer_name" {
  description = "The name of the cert-manager cluster issuer"
  type        = string
}
