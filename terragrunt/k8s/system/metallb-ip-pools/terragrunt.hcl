include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

dependency "metallb" {
  config_path  = "../metallb"
  skip_outputs = true
}

inputs = {
  address_pool_name = "nodes-pool"
  namespace         = dependency.metallb.inputs.namespace
  ips = [
    include.root.locals.env.vm_network.nodes.control-plane-master,
  ]
}