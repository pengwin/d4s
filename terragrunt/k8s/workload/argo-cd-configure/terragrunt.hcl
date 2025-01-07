terraform {
  source = "../../../../terraform/argo-cd-configure"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "argo-cd-creds" {
  config_path = "../argo-cd-creds"

  mock_outputs = {
    argocd_username = "mock argocd username"
    argocd_password = "mock argocd password"
  }
}

dependency "gitea-configure" {
  config_path = "../gitea-configure"

  mock_outputs = {
    hello_world_deploy_ssh    = "mock hello world deploy ssh"
    argocd_deploy_private_key = "mock argocd deploy private key"
  }
}

dependency "gitea-create-repos" {
  config_path = "../gitea-create-repos"

  skip_outputs = true
}

inputs = {
  argocd_domain = include.root.locals.env.argocd_domain

  argocd_admin_username = dependency.argo-cd-creds.outputs.argocd_username
  argocd_admin_password = dependency.argo-cd-creds.outputs.argocd_password

  hello_world_deploy_ssh    = dependency.gitea-configure.outputs.hello_world_deploy_ssh
  argocd_deploy_private_key = dependency.gitea-configure.outputs.argocd_deploy_private_key
}