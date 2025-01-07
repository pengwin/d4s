locals {
  env_config = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env        = local.env_config.locals
}

terraform {
  source = "../../terraform/k8s-cluster"
}

dependency "ca_cert" {
  config_path = "../kubernetes-ca"

  mock_outputs = {
    ca_cert = "mock cert pem"
    ca_key  = "mock key pem"
  }
}

inputs = {
  cluster_name      = local.env.cluster_name
  host_ip           = local.env.vm_network.host_ip
  ansible_base_path = "${get_terragrunt_dir()}/../../ansible"

  ca_cert_pem = dependency.ca_cert.outputs.ca_cert
  ca_key_pem  = dependency.ca_cert.outputs.ca_key

  kubeconfig_file_path = local.env.kubeconfig_file_path

  vms = {
    control-plane-master = {
      ip     = local.env.vm_network.nodes.control-plane-master
      cpus   = 2
      memory = 2048
    }
    worker-node-1 = {
      ip     = local.env.vm_network.nodes.worker-node-1
      cpus   = 2
      memory = 2048
    }
    worker-node-2 = {
      ip     = local.env.vm_network.nodes.worker-node-2
      cpus   = 2
      memory = 2048
    }
  }

}