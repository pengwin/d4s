include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "ca_cert" {
  config_path = "../kubernetes-ca"

  mock_outputs = {
    ca_cert = "mock cert pem"
    ca_key  = "mock key pem"
  }
}

dependency "k8s_cluster" {
  config_path = "../k8s_cluster"

  mock_outputs = {
    k8s_admin_conf_path = "mock admin conf path"
  }
}

inputs = {
  key_file_path  = include.env.locals.ca_key_file_path
  cert_file_path = include.env.locals.ca_cert_file_path

  ca_key_file_pem  = dependency.ca_cert.outputs.ca_key
  ca_cert_file_pem = dependency.ca_cert.outputs.ca_cert

  kubeconfig_source_path = dependency.k8s_cluster.outputs.k8s_admin_conf_path
  kubeconfig_file_path   = include.env.locals.kubeconfig_file_path
}