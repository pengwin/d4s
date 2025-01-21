terraform {
  source = find_in_parent_folders("terraform/argo-cd-configure")
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "argo-cd" {
  config_path  = find_in_parent_folders("argo-cd")
  skip_outputs = true
}

dependency "gitea-configure" {
  config_path = find_in_parent_folders("gitea-configure")

  mock_outputs = {
    hello_world_deploy_ssh    = "mock hello world deploy ssh"
    argocd_deploy_private_key = "mock argocd deploy private key"
  }
}

dependency "gitea-create-repos" {
  config_path = find_in_parent_folders("gitea-create-repos")

  skip_outputs = true
}

inputs = {
  argocd_domain = include.root.locals.env.argocd_domain
  argocd_credentials_secret = {
    name      = "argocd-initial-admin-secret"
    namespace = dependency.argo-cd.inputs.namespace
  }

  hello_world_deploy_ssh    = dependency.gitea-configure.outputs.hello_world_deploy_ssh
  argocd_deploy_private_key = dependency.gitea-configure.outputs.argocd_deploy_private_key
}