locals {
  env_config = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env        = local.env_config.locals
}

dependency "k8s-cluster" {
  config_path = find_in_parent_folders("k8s-cluster")

  skip_outputs = true
}

generate "_k8s_providers.tf" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
    config_path = "${local.env.kubeconfig_file_path}"
}
provider "helm" {
   kubernetes {
    config_path = "${local.env.kubeconfig_file_path}"
  }
}
EOF
}