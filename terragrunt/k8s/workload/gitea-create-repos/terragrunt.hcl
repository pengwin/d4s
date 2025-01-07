terraform {
  source = "../../../../terraform/gitea-create-repos"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "gitea-configure" {
  config_path = "../gitea-configure"

  mock_outputs = {
    hello_world_deploy_push_url = "mock url"
  }
}

inputs = {
  repo_path                   = get_working_dir()
  hello_world_deploy_push_url = dependency.gitea-configure.outputs.hello_world_deploy_push_url
}