variable "name" {
  description = "Name of the PostgreSQL cluster"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy the PostgreSQL cluster"
  type        = string
}

variable "instances" {
  description = "Number of instances in the PostgreSQL cluster"
  type        = number
}

variable "storage_class" {
  description = "Storage class to use for the PostgreSQL cluster"
  type        = string
}

variable "size" {
  description = "Size of the storage for the PostgreSQL cluster"
  type        = string
}

variable "username" {
  description = "Username for the PostgreSQL admin user"
  type        = string
}

variable "database" {
  description = "Name of the database to create"
  type        = string
}