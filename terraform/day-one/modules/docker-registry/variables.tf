variable "chart_version" {
  description = "The version of docker-registry.helm chart to install"
  type        = string
  default     = "2.2.3"
}

variable "namespace" {
  description = "The namespace to install docker-registry.helm controller into"
  type        = string
  default     = "docker-registry"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "docker-registry"
}

variable "storage_class_name" {
  description = "The name of the storage class for the registry"
  type        = string
}
