provider "kubernetes" {
  config_path = var.kubeconfig_file_path
}

data "kubernetes_secret" "argo_secret" {
  metadata {
    name      = var.argocd_admin_secret_name
    namespace = var.argocd_namespace
  }
}

output "argocd_username" {
  value = "admin"
}

output "argocd_password" {
  value     = data.kubernetes_secret.argo_secret.data["password"]
  sensitive = true
}

data "kubernetes_secret" "gitea_secret" {
  metadata {
    name      = var.gitea_admin_secret_name
    namespace = var.gitea_namespace
  }
}

output "gitea_username" {
  value     = data.kubernetes_secret.gitea_secret.data["username"]
  sensitive = true
}

output "gitea_password" {
  value     = data.kubernetes_secret.gitea_secret.data["password"]
  sensitive = true
}



