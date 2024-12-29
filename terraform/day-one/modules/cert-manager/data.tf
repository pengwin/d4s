data "local_file" "ca_cert" {
  filename = var.ca_cert_file_path
}

data "local_file" "ca_key" {
  filename = var.ca_key_file_path
}