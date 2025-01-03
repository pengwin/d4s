output "key_file_path" {
  value       = var.key_file_path
  description = "Path to the file where the private key will be saved"
}

output "cert_file_path" {
  value       = var.cert_file_path
  description = "Path to the file where the certificate will be saved"
}

output "kubeconfig_file_path" {
  value       = var.kubeconfig_file_path
  description = "Path to save the kubeconfig file"
}
