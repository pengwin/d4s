variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
}

variable "vms" {
  description = "The configuration of the Kubernetes cluster VMs"
  type = map(object({
    ip     = string
    cpus   = number
    memory = number
  }))
}

variable "ansible_base_path" {
  description = "The base path for the Ansible playbooks"
  type        = string
}

variable "host_ip" {
  description = "The IP address of the host machine inside virtual machines"
  type        = string
}

variable "ca_key_pem" {
  description = "The CA certificate key PEM"
  type        = string
  sensitive   = true
}

variable "ca_cert_pem" {
  description = "The CA certificate PEM"
  type        = string
  sensitive   = true
}

variable "kubeconfig_file_path" {
  description = "Path to save the kubeconfig file"
  type        = string
}
