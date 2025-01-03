variable "common_name" {
  description = "The common name for the CA certificate"
  type        = string
}

variable "country" {
  description = "The country for the CA certificate"
  type        = string
}

variable "city" {
  description = "The city for the CA certificate"
  type        = string
}

variable "company" {
  description = "The company for the CA certificate"
  type        = string
}

variable "validity_period_hours" {
  description = "The validity period for the CA certificate in hours"
  type        = number
}
