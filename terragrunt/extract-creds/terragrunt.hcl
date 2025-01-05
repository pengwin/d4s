terraform {
  source = "."
}


include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "copy_files" {
  config_path = "../copy_files"

  mock_outputs = {
    kubeconfig_file_path = "mock path"
  }
}

dependency "day_one" {
  config_path = "../day_one"

  mock_outputs = {
    gitea_admin_secret_name = "mock gitea admin secret name"
    gitea_domain    = "mock gitea domain"
    gitea_namespace = "mock gitea namespace"

    argocd_admin_secret_name = "mock argocd admin secret name"
    argocd_domain = "mock argocd domain"
    argocd_namespace = "mock argocd namespace"
  }
}


inputs = {
  kubeconfig_file_path = dependency.copy_files.outputs.kubeconfig_file_path

  argocd_admin_secret_name = dependency.day_one.outputs.argocd_admin_secret_name
  argocd_namespace = dependency.day_one.outputs.argocd_namespace

  gitea_admin_secret_name = dependency.day_one.outputs.gitea_admin_secret_name
  gitea_namespace = dependency.day_one.outputs.gitea_namespace
}