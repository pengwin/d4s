data "kubernetes_secret" "argo_secret" {
  metadata {
    name      = var.argocd_credentials_secret.name
    namespace = var.argocd_credentials_secret.namespace
  }
}

provider "argocd" {
  username    = "admin"
  password    = data.kubernetes_secret.argo_secret.data["password"]
  server_addr = var.argocd_domain
  insecure    = true
}
