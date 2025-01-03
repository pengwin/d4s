# Save to a local file

resource "local_file" "ca_cert" {
  content  = var.ca_cert_file_pem
  filename = var.cert_file_path
}

resource "local_file" "ca_key" {
  content  = var.ca_key_file_pem
  filename = var.key_file_path
}

data "local_file" "kubeconfig" {
  filename = var.kubeconfig_source_path
}

resource "local_file" "kubeconfig" {
  content  = data.local_file.kubeconfig.content
  filename = var.kubeconfig_file_path
}
