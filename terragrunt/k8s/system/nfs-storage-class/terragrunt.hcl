include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

dependency "csi-driver-nfs" {
  config_path  = find_in_parent_folders("csi-driver-nfs")
  skip_outputs = true
}

inputs = {
  storage_class_name = "nfs-storage-class"
  nfs_server = {
    server = include.root.locals.env.vm_network.host_ip
    share  = "/srv/nfs/k8s_csi"
  }
}