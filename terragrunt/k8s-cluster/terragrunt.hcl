locals {
  env_config = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env        = local.env_config.locals

  cluster_name = local.env.cluster_name
  host_ip      = local.env.vm_network.host_ip

  kubeconfig_file_path = local.env.kubeconfig_file_path

  admin_username        = "vagrant_admin"
  k8s_playbook_file     = "kubernetes_playbook.yaml"
  ansible_base_path     = "${get_terragrunt_dir()}/../../ansible"
  ansible_playbook_path = "${local.ansible_base_path}/${local.k8s_playbook_file}"

  vms = { for vm_name, vm_ip in local.env.vm_network.nodes : vm_name => {
    ip            = vm_ip
    cpus          = 2
    memory        = 2048
    vdisk_size_gb = 15
  } }

  vms_json = urlencode(jsonencode(local.vms))
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

/*
vms = JSON.parse(ENV["VMS"])
cluster_name = ENV["CLUSTER_NAME"]
host_ip = ENV["HOST_IP"]
username = ENV["USERNAME"]
ca_cert_pem = ENV["CA_CERT_PEM"]
ca_key_pem = ENV["CA_KEY_PEM"]
ansible_playbook_path = ENV["ANSIBLE_PLAYBOOK_PATH"]
*/

generate "cluster-config.rb" {
  path      = "cluster-config.rb"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
require 'uri'
require 'json'

class ClusterConfig
  def self.vms()
    json = URI.decode_www_form_component("${local.vms_json}")
    JSON.parse(json)
  end
  def self.cluster_name()
    "${local.cluster_name}"
  end
  def self.host_ip()
    "${local.host_ip}"
  end
  def self.username()
    "${local.admin_username}"
  end
  def self.ca_cert_pem()
    "${dependency.ca_cert.outputs.ca_cert}"
  end
  def self.ca_key_pem()
    "${dependency.ca_cert.outputs.ca_key}"
  end
  def self.ansible_playbook_path()
    "${local.ansible_playbook_path}"
  end
end
EOF
}

inputs = {
  kubeconfig_file_path = local.kubeconfig_file_path
  admin_username       = local.admin_username
  ansible_base_path    = local.ansible_base_path
  cluster_name         = local.cluster_name
}