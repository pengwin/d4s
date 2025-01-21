include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = find_in_parent_folders("terraform/base-helm")
}

dependency "pi-hole" {
  config_path  = find_in_parent_folders("pi-hole")
  skip_outputs = true
}

inputs = {
  repository    = "https://kubernetes-sigs.github.io/external-dns/"
  chart         = "external-dns"
  chart_version = "1.15.0"
  namespace     = dependency.pi-hole.inputs.namespace
  release_name  = "external-dns"

  values = {
    provider = {
      name = "pihole"
    }
    registry = "noop"
    policy   = "upsert-only"
    env = [
      {
        name  = "EXTERNAL_DNS_PIHOLE_SERVER"
        value = "http://pi-hole-web"
      },
      {
        name = "EXTERNAL_DNS_PIHOLE_PASSWORD",
        valueFrom = {
          secretKeyRef = {
            name = dependency.pi-hole.inputs.values.web_password_secret_name
            key  = "password"
          }
        }

      }
    ]
  }
}