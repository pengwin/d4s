variable "pi_hole_ip" {
  description = "The IP address of the pi-hole server"
  type        = string
}

import {
  to = kubernetes_config_map.coredns
  id = "kube-system/coredns"
}

resource "kubernetes_config_map" "coredns" {
  metadata {
    name      = "coredns"
    namespace = "kube-system"
  }

  data = {
    Corefile           = <<EOF
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward test-kubernetes ${var.pi_hole_ip}
        forward . /etc/resolv.conf {
           max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
    EOF
  }
}