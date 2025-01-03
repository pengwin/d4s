output "ca_cert" {
  value = tls_self_signed_cert.ca_cert.cert_pem
  sensitive = true
}

output "ca_key" {
  value = tls_private_key.ca_private_key.private_key_pem
  sensitive = true
}