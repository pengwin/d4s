variable "argocd_domain" {
  description = "The domain where ArgoCD is available"
  type        = string
}

variable "argocd_admin_username" {
  description = "The username of the ArgoCD admin"
  type        = string
}

variable "argocd_admin_password" {
  description = "The password of the ArgoCD admin"
  type        = string
}

variable "hello_world_deploy_ssh" {
  description = "The SSH URL of the hello-world-deploy repository"
  type        = string
}

variable "argocd_deploy_private_key" {
  description = "The private key of the deploy key for the hello-world-deploy repository"
  type        = string
}
