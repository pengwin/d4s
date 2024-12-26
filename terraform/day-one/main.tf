locals {
  storage_class_name = "nfs-storage-class"
  cluster_issuer_name = "selfsigned-cluster-issuer"
}

module "ingress_nginx" {
  source = "./modules/ingress-nginx"

  namespace     = "ingress-nginx"
  chart_version = "4.11.3"
  release_name  = "ingress-nginx"
}

module "csi-driver-nfs" {
  source = "./modules/csi-driver-nfs"

  namespace     = "kube-system"
  chart_version = "4.9.0"
  release_name  = "csi-driver-nfs"

  storage_class_name = local.storage_class_name
  nfs_server = {
    server = "192.168.121.1"
    share  = "/srv/nfs/k8s_csi"
  }
}

module "cert_manager" {
  source = "./modules/cert-manager"

  namespace     = "cert-manager"
  chart_version = "1.16.2"
  release_name  = "cert-manager"

  cluster_issuer_name = local.cluster_issuer_name
}

module "docker-registry" {
  source = "./modules/docker-registry"

  namespace     = "docker-registry"
  chart_version = "2.2.3"
  release_name  = "docker-registry"

  storage_class_name = local.storage_class_name

  depends_on = [module.csi-driver-nfs, module.ingress_nginx, module.cert_manager]
}

