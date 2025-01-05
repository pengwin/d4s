terraform {
  source = "../../terraform/day-one"
}

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
    host_ip             = "mock host ip"
    k8s_admin_conf_path = "mock admin conf path"
    vms = {
      control-plane-master = "mock ip"
      worker-node-1        = "mock ip"
    }
  }
}

inputs = {
  cluster_nodes          = dependency.k8s_cluster.outputs.vms
  ca_key_file_pem        = dependency.ca_cert.outputs.ca_key
  ca_cert_file_pem       = dependency.ca_cert.outputs.ca_cert
  kubeconfig_file_path   = dependency.k8s_cluster.outputs.k8s_admin_conf_path
  nfs_server             = dependency.k8s_cluster.outputs.host_ip
  pi_hole_password       = include.env.locals.pi_hole_password
}