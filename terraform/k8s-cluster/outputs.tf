output "vms" {
  value = {
    for name, vm in var.vms : name => vm.ip
  }
}

output "host_ip" {
  value = var.host_ip
}

output "k8s_admin_conf_path" {
  value = local.k8s_admin_conf_path
}
