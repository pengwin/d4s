include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "extract_creds" {
  config_path = "../extract-creds"

  mock_outputs = {
    argocd_username = "mock argocd username"
    argocd_password = "mock argocd password"
  }
}

dependency "day_one" {
  config_path = "../day_one"

  mock_outputs = {
    gitea_admin_secret_name = "mock gitea admin secret name"
    gitea_domain    = "mock gitea domain"
    gitea_namespace = "mock gitea namespace"

    argocd_domain = "mock argocd domain"
    argocd_namespace = "mock argocd namespace"
  }
}

dependency "gitea_setup" {
  config_path = "../gitea_setup"

  mock_outputs = {
    hello_world_deploy_ssh = "mock hello world deploy ssh"
    argocd_deploy_private_key = "mock argocd deploy private key"
  }
}


inputs = {
  kubeconfig_file_path = dependency.day_one.inputs.kubeconfig_file_path

  argocd_domain = dependency.day_one.outputs.argocd_domain
  argocd_admin_username = dependency.extract_creds.outputs.argocd_username
  argocd_admin_password = dependency.extract_creds.outputs.argocd_password

  hello_world_deploy_ssh = dependency.gitea_setup.outputs.hello_world_deploy_ssh
  argocd_deploy_private_key = dependency.gitea_setup.outputs.argocd_deploy_private_key
}