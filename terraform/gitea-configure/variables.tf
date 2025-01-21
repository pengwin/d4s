variable "gitea_domain" {
  description = "The domain where gitea is available"
  type        = string
}

variable "gitea_admin_secret_name" {
  description = "Name of the kubernetes secret containing gitea admin credentials"
  type        = string
}

variable "gitea_admin_secret_namespace" {
  description = "Namespace of the kubernetes secret containing gitea admin credentials"
  type        = string
}