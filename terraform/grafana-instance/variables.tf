variable "name" {
  description = "Name of the Grafana instance"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy the Grafana instance"
  type        = string
}

variable "instances" {
  description = "Number of instances in the Grafana instance"
  type        = number
}

variable "storage_class" {
  description = "Storage class to use for the Grafana instance"
  type        = string
}

variable "size" {
  description = "Size of the storage for the Grafana instance"
  type        = string
}

variable "admin_secret_name" {
  description = "Name of the secret to store the admin credentials"
  type        = string
}

variable "username" {
  description = "Username for the Grafana admin user"
  type        = string
  sensitive   = true
}

variable "hostname" {
  description = "Hostname for the Grafana instance"
  type        = string
}

variable "cluster_issuer_name" {
  description = "Name of the cert-manager cluster issuer"
  type        = string

}

variable "init_containers" {
  description = "Init containers configuration"
  type        = list(any)
}

variable "allow_loading_unsigned_plugins" {
  description = "Allow loading unsigned plugins"
  type        = string
}

/*variable "password" {
  description = "Name of the database to create"
  type        = string
  sensitive   = true
}*/
