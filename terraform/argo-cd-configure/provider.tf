provider "argocd" {
  username    = var.argocd_admin_username
  password    = var.argocd_admin_password
  server_addr = var.argocd_domain
  insecure    = true
}