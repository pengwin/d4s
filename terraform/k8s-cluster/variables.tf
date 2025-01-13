variable "ansible_base_path" {
  description = "The base path for the Ansible playbooks"
  type        = string
}

variable "kubeconfig_file_path" {
  description = "Path to save the kubeconfig file"
  type        = string
}

variable "admin_username" {
  description = "The username of the Kubernetes admin"
  type        = string
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string  
}