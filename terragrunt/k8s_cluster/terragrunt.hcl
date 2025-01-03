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
  host_ip           = "172.16.122.5"
  ansible_base_path = "${get_terragrunt_dir()}/../../ansible"

  ca_cert_pem = dependency.ca_cert.outputs.ca_cert

  vms = {
    control-plane-master = {
      ip     = "172.16.122.10"
      cpus   = 2
      memory = 2048
    }
    worker-node-1 = {
      ip     = "172.16.122.13"
      cpus   = 2
      memory = 2048
    }
  }

}