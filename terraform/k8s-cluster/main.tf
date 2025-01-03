locals {
  cluster_name   = "test-kubernetes"
  admin_username = "vagrant_admin"

  k8s_playbook_file   = "kubernetes_playbook.yaml"
  k8s_admin_conf_path = "${var.ansible_base_path}/fetched/control-plane-master/home/vagrant/${local.admin_username}.conf"

  ansible_playbook_path = "${var.ansible_base_path}/${local.k8s_playbook_file}"
  vms_json              = jsonencode(var.vms)
}

resource "vagrant_vm" "k8s_vms" {
  name = "${local.cluster_name}-vms"
  env = {
    CLUSTER_NAME = local.cluster_name
    HOST_IP      = var.host_ip
    USERNAME     = local.admin_username
    CA_CERT_PEM  = var.ca_cert_pem
    VMS          = local.vms_json

    ANSIBLE_PLAYBOOK_PATH = local.ansible_playbook_path

    # force terraform to re-run vagrant if the Vagrantfile changes
    VAGRANTFILE_HASH = md5(file("./Vagrantfile"))
  }
  get_ports = false
}
