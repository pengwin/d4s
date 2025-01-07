include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../../terraform/base-helm"
}


dependency "nfs-storage-class" {
  config_path  = "../../system/nfs-storage-class"
  skip_outputs = true
}

dependency "cert-issuer" {
  config_path  = "../../system/cert-issuer"
  skip_outputs = true
}

dependency "ingress-nginx" {
  config_path  = "../../system/ingress-nginx"
  skip_outputs = true
}

inputs = {
  repository    = "https://helm.twun.io"
  chart         = "docker-registry"
  chart_version = "2.2.3"
  namespace     = "docker-registry"
  release_name  = "docker-registry"

  values = {
    persistence = {
      enabled      = true
      size         = "2Gi"
      storageClass = dependency.nfs-storage-class.inputs.storage_class_name
    }

    service = {
      type = "ClusterIP"
      port = 80
    }

    ingress = {
      enabled = true
      annotations = {
        "nginx.ingress.kubernetes.io/proxy-body-size" = "50m"
        "nginx.org/proxy-body-size"                   = "50m",
        "cert-manager.io/cluster-issuer"              = dependency.cert-issuer.inputs.cluster_issuer_name
      }
      hosts = [
        include.root.locals.env.docker_registry_domain
      ]
      path = "/"
      tls = [
        {
          secretName = "docker-reg-tls"
          hosts = [
            include.root.locals.env.docker_registry_domain
          ]
        }
      ]
    }

  }
}