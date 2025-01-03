variable "ca_key_file_pem" {
  description = "Content of the CA private key PEM"
  type        = string
  sensitive   = true
}

variable "ca_cert_file_pem" {
  description = "Content of the CA certificate PEM"
  type        = string
  sensitive   = true
}

variable "key_file_path" {
  description = "Path to the file where the private key will be saved"
  type        = string
}

variable "cert_file_path" {
  description = "Path to the file where the certificate will be saved"
  type        = string
}

variable "kubeconfig_source_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "kubeconfig_file_path" {
  description = "Path to save the kubeconfig file"
  type        = string
}
