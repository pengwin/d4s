include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}

dependency "metallb_ip_pools" {
  config_path  = find_in_parent_folders("metallb-ip-pools")
  skip_outputs = true
}


inputs = {
  repository    = "https://kubernetes.github.io/ingress-nginx"
  chart         = "ingress-nginx"
  chart_version = "4.11.3"
  namespace     = "ingress-nginx"
  release_name  = "ingress-nginx"

  values = {
    controller = {
      service = {
        kind = "daemonset"
        type = "LoadBalancer"
        annotations = {
          "metallb.universe.tf/address-pool" = dependency.metallb_ip_pools.inputs.address_pool_name
          "metallb.io/allow-shared-ip"       = include.root.locals.env.lb_shared_ip
        }
      }
    }
  }
}