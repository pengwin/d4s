include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

dependency "pi-hole" {
  config_path  = find_in_parent_folders("pi-hole")
  skip_outputs = true
}

inputs = {
  pi_hole_ip = include.root.locals.env.vm_network.nodes.control-plane-master
}