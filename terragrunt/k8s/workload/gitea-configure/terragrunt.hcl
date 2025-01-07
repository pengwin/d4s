terraform {
  source = "../../../../terraform/gitea-configure"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "gitea" {
  config_path = "../gitea"

  mock_outputs = {
    gitea_admin_username = "mock gitea admin"
    gitea_admin_password = "mock gitea password"
  }
}

generate "gitea_provider" {
  path      = "_gitea_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "gitea" {
  base_url = "https://${include.root.locals.env.gitea_domain}"
  username = "${dependency.gitea.outputs.gitea_admin_username}"
  password = "${dependency.gitea.outputs.gitea_admin_password}"
  insecure = true
}
provider "local" {
}
EOF
}

inputs = {
  gitea_domain = include.root.locals.env.gitea_domain
}