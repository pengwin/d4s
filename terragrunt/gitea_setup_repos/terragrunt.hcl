terraform {
  source = "."
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "gitea_setup" {
  config_path = "../gitea_setup"

  mock_outputs = {
    hello_world_deploy_push_url = "mock url"
  }
}

inputs = {
  repo_path = get_working_dir()
  hello_world_deploy_push_url = dependency.gitea_setup.outputs.hello_world_deploy_push_url
}