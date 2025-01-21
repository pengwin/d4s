include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}

dependency "ingress-nginx" {
  config_path  = find_in_parent_folders("system/ingress-nginx")
  skip_outputs = true
}

dependency "cert-issuer" {
  config_path  = find_in_parent_folders("system/cert-issuer")
  skip_outputs = true
}

locals {
  web_password_secret_name = "pi-hole-web-password"
  namespace                = "external-dns"
}

generate "_namespace.tf" {
  path      = "_namespace.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "kubernetes_namespace" "pihole" {
  metadata {
    name = "${local.namespace}"
  }
}
EOF
}

generate "_passwords.tf" {
  path      = "_passwords.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
resource "random_password" "pihole_web_password" {
  length  = 16
  special = true
}

resource "kubernetes_secret" "web_password" {
  metadata {
    name      = "${local.web_password_secret_name}"
    namespace = "${local.namespace}"
  }

  data = {
    password = random_password.pihole_web_password.result
  }
}
EOF
}

inputs = {
  repository       = null
  chart            = "${get_working_dir()}/chart"
  chart_version    = null
  namespace        = local.namespace
  release_name     = "pi-hole"
  create_namespace = false

  values = {
    image = {
      repository = "docker.io/pihole/pihole"
      pullPolicy = "Always"
      tag        = "2024.07.0"
    }

    web_password_secret_name = local.web_password_secret_name

    service = {
      containerPort = 5000
      allowSharedIp = include.root.locals.env.lb_shared_ip
    }

    ingress = {
      host       = include.root.locals.env.pi_hole_domain
      certIssuer = dependency.cert-issuer.inputs.cluster_issuer_name
    }
  }
}