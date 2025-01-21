include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}

dependency "cert-issuer" {
  config_path  = find_in_parent_folders("system/cert-issuer")
  skip_outputs = true
}

dependency "ingress-nginx" {
  config_path  = find_in_parent_folders("system/ingress-nginx")
  skip_outputs = true
}

inputs = {
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  chart_version    = "7.0.0"
  namespace        = "argo-cd"
  release_name     = "argo-cd"
  create_namespace = true

  values = {
    global = {
      domain = include.root.locals.env.argocd_domain
    }

    configs = {
      params = {
        "server.insecure" = true
      }
    }

    server = {
      ingress = {
        enabled          = true
        ingressClassName = "nginx"
        annotations = {
          "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
          "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
          "cert-manager.io/cluster-issuer"                 = dependency.cert-issuer.inputs.cluster_issuer_name
        }

        tls = true
      }
    }
  }
}