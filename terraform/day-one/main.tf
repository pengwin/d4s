locals {
  storage_class_name  = "nfs-storage-class"
  cluster_issuer_name = "selfsigned-cluster-issuer"
}

module "flannel" {
  source = "./modules/flannel"

  namespace     = "kube-flannel"
  chart_version = "0.26.2"
  release_name  = "flannel"
}

module "metallb" {
  source = "./modules/metallb"

  namespace     = "metallb-system"
  chart_version = "0.14.9"
  release_name  = "metallb"

  cluster_master_ip   = var.cluster_master_ip
  cluster_worker_node = var.cluster_worker_node_ip

  depends_on = [module.flannel]
}

module "ingress_nginx" {
  source = "./modules/ingress-nginx"

  namespace     = "ingress-nginx"
  chart_version = "4.11.3"
  release_name  = "ingress-nginx"

  depends_on = [module.metallb]
}

module "csi-driver-nfs" {
  source = "./modules/csi-driver-nfs"

  namespace     = "kube-system"
  chart_version = "4.9.0"
  release_name  = "csi-driver-nfs"

  storage_class_name = local.storage_class_name
  nfs_server = {
    server = var.nfs_server
    share  = "/srv/nfs/k8s_csi"
  }

  depends_on = [module.flannel]
}

module "cert_manager" {
  source = "./modules/cert-manager"

  namespace     = "cert-manager"
  chart_version = "1.16.2"
  release_name  = "cert-manager"

  cluster_issuer_name = local.cluster_issuer_name
  ca_cert_file_pem    = var.ca_cert_file_pem
  ca_key_file_pem     = var.ca_key_file_pem

  depends_on = [module.flannel]
}

module "docker-registry" {
  source = "./modules/docker-registry"

  namespace     = "docker-registry"
  chart_version = "2.2.3"
  release_name  = "docker-registry"

  storage_class_name  = local.storage_class_name
  cluster_issuer_name = local.cluster_issuer_name

  depends_on = [module.csi-driver-nfs, module.ingress_nginx, module.cert_manager]
}

module "pi_hole" {
  source = "./modules/pi-hole"

  namespace     = "pi-hole"
  release_name  = "pi-hole"

  pi_hole_password = var.pi_hole_password

  depends_on = [module.ingress_nginx]
}

module "external-dns" {
  source = "./modules/external-dns"

  namespace     = "external-dns"
  chart_version = "1.15.0"
  release_name  = "external-dns"

  pi_hole_password = var.pi_hole_password

  depends_on = [module.pi_hole]
}

module "argo-cd" {
  source = "./modules/argo-cd"

  namespace     = "argo-cd"
  chart_version = "7.0.0"
  release_name  = "argo-cd"

  depends_on = [module.ingress_nginx]
}

module "metrics-server" {
  source = "./modules/metrics-server"

  namespace     = "metrics-server"
  chart_version = "3.12.2"
  release_name  = "metrics-server"

  cluster_issuer_name = local.cluster_issuer_name

  depends_on = [module.cert_manager]
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

  depends_on = [module.ingress_nginx]
}

