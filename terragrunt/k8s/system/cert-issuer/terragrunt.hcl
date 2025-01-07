include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

dependency "cert-manager" {
  config_path  = "../cert-manager"
  skip_outputs = true
}

dependency "ca_cert" {
  config_path = "../../../kubernetes-ca"

  mock_outputs = {
    ca_cert = "mock cert pem"
    ca_key  = "mock key pem"
  }
}

inputs = {
  namespace           = dependency.cert-manager.inputs.namespace
  ca_secret_name      = "ca-cert"
  cluster_issuer_name = "selfsigned-cluster-issuer"
  ca_cert = {
    tls_crt = dependency.ca_cert.outputs.ca_cert
    tls_key = dependency.ca_cert.outputs.ca_key
  }
}