variable "kubeconfig_file_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "argocd_admin_secret_name" {
  description = "The name of the secret containing the ArgoCD admin credentials"
  type        = string
}

variable "argocd_namespace" {
  description = "The namespace where ArgoCD is installed"
  type        = string
}

variable "gitea_admin_secret_name" {
  description = "The name of the secret containing the Gitea admin credentials"
  type        = string
}

variable "gitea_namespace" {
  description = "The namespace where Gitea is installed"
  type        = string
}