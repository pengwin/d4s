terraform {
  source = "."
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "extract_creds" {
  config_path = "../extract-creds"

  mock_outputs = {
    gitea_username = "mock gitea username"
    gitea_password = "mock gitea password"
  }
}

dependency "day_one" {
  config_path = "../day_one"

  mock_outputs = {
    gitea_domain    = "mock gitea domain"
  }
}


inputs = {
  gitea_admin_username = dependency.extract_creds.outputs.gitea_username
  gitea_admin_password = dependency.extract_creds.outputs.gitea_password
  gitea_domain = dependency.day_one.outputs.gitea_domain
  repo_path = get_working_dir()
}