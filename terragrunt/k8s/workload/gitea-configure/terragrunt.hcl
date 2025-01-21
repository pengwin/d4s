terraform {
  source = find_in_parent_folders("terraform/gitea-configure")
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "gitea" {
  config_path  = find_in_parent_folders("gitea")
  skip_outputs = true
}

dependency "gitea-ns" {
  config_path  = find_in_parent_folders("gitea-ns")
  skip_outputs = true
}

inputs = {
  gitea_domain                 = include.root.locals.env.gitea_domain
  gitea_admin_secret_name      = dependency.gitea.inputs.values.gitea.admin.existingSecret
  gitea_admin_secret_namespace = dependency.gitea-ns.inputs.name
}