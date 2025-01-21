include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/postgres-cluster")
}

dependency "gitea-ns" {
  config_path  = find_in_parent_folders("gitea-ns")
  skip_outputs = true
}

dependency "nfs-storage-class" {
  config_path  = find_in_parent_folders("system/nfs-storage-class")
  skip_outputs = true
}

dependency "postgres-operator" {
  config_path  = find_in_parent_folders("db/cnpg-postgres-operator")
  skip_outputs = true
}

inputs = {
  name          = "gitea-pg"
  namespace     = dependency.gitea-ns.inputs.name
  instances     = 1
  storage_class = dependency.nfs-storage-class.inputs.storage_class_name
  size          = "1Gi"

  username = "gitea"
  database = "gitea"
}