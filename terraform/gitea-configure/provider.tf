
data "kubernetes_secret" "gitea_admin" {
  metadata {
    name      = var.gitea_admin_secret_name
    namespace = var.gitea_admin_secret_namespace
  }
}

provider "gitea" {
  base_url = "https://${var.gitea_domain}"
  username = data.kubernetes_secret.gitea_admin.data["username"]
  password = data.kubernetes_secret.gitea_admin.data["password"]
  insecure = true
}

provider "local" {
}
