module "external-dns" {
  source = "./modules/external-dns"

  namespace     = "external-dns"
  chart_version = "1.15.0"
  release_name  = "external-dns"
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
    Corefile = <<EOF
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        hosts /etc/coredns/test_kubernetes_db test-kubernetes {
          fallthrough
        }
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward . /etc/resolv.conf {
           max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
    EOF
    test_kubernetes_db = <<EOF
    # This is a custom domain file for CoreDNS
    # Format: <IP> <DOMAIN>
    ${var.cluster_master_ip} docker-registry.test-kubernetes
    EOF
  }

  depends_on = [module.external-dns]
}
