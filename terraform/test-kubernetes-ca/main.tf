resource "tls_private_key" "ca_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca_private_key.private_key_pem

  is_ca_certificate = true

  subject {
    country             = "RS"
    province            = "Belgrade"
    locality            = "Belgrade"
    common_name         = "Test K8S CA"
    organization        = "Test K8S"
    organizational_unit = "Test K8S"
  }

  validity_period_hours = 24 * 365

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

# Save to a local file

resource "local_file" "ca_cert" {
  content  = tls_self_signed_cert.ca_cert.cert_pem
  filename = var.cert_file_path
}

resource "local_file" "ca_key" {
  content  = tls_private_key.ca_private_key.private_key_pem
  filename = var.key_file_path
}