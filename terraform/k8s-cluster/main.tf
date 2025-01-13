locals {
  k8s_admin_conf_path = "${var.ansible_base_path}/fetched/control-plane-master/home/vagrant/${var.admin_username}.conf"
}

resource "vagrant_vm" "k8s_vms" {
  name = "${var.cluster_name}-vms"
  env = {
    # force terraform to re-run vagrant if the Vagrantfile changes
    VAGRANTFILE_HASH = md5(file("./Vagrantfile"))
  }
  get_ports = false
}

resource "local_sensitive_file" "kube_conf" {
  source   = local.k8s_admin_conf_path
  filename = var.kubeconfig_file_path

  depends_on = [vagrant_vm.k8s_vms]
}
