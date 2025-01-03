resource "tls_private_key" "ca_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca_private_key.private_key_pem

  is_ca_certificate = true

  subject {
    country             = var.country
    province            = var.city
    locality            = var.city
    common_name         = var.common_name
    organization        = var.company
    organizational_unit = var.company
  }

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing"
  ]
}
