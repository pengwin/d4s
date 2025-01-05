provider "gitea" {
  base_url = "https://${var.gitea_domain}"
  username = var.gitea_admin_username
  password = var.gitea_admin_password
  insecure = true
}
