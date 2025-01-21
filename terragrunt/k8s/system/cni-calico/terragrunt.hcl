include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}

inputs = {
  repository    = "https://docs.tigera.io/calico/charts"
  chart         = "tigera-operator"
  chart_version = "v3.29.1"
  namespace     = "tigera-operator"
  release_name  = "tigera-operator"

  values = {
    apiServer = {
      enabled = false
    }
    installation = {
      cni = {
        type = "Calico"
      }
      calicoNetwork = {
        linuxDataplane = "Nftables"
        bgp            = "Disabled"
        ipPools = [
          {
            name          = "default-ipv4-ippool"
            cidr          = "10.244.0.0/16"
            encapsulation = "VXLAN"
            #natOutgoing   = "Disabled"
          }
        ]
        nodeAddressAutodetectionV4 = {
          interface = "eth1" # use interface of 172.16.122.0
        }
      }
    }
  }
}