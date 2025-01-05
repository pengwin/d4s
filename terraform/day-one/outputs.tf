output "gitea_admin_secret_name" {
  value = local.gitea_admin_secret_name
}

output "gitea_domain" {
  value = local.gitea_domain
}

output "argocd_domain" {
  value = local.argocd_domain
}

output "gitea_namespace" {
  value = local.gitea_namespace
}

output "argocd_namespace" {
  value = local.argocd_namespace
}

output "argocd_admin_secret_name" {
  value = "argocd-initial-admin-secret"
}

