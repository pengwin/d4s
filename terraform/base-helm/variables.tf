variable "chart_version" {
  description = "The version of the metrics-server chart to install"
  type        = string
}

variable "repository" {
  description = "The repository to install the metrics-server chart from"
  type        = string
}

variable "chart" {
  description = "The name of the chart to install"
  type        = string
}

variable "namespace" {
  description = "The namespace to install the metrics-server controller into"
  type        = string
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist"
  type        = bool
  default     = true
}

variable "values" {
  description = "The values to pass to the helm chart"
  type        = any
}

variable "timeout" {
  description = "The timeout for the helm chart installation"
  type        = number
  default     = 60 * 3
}

variable "atomic" {
  description = "Rollback the release if it fails"
  type        = bool
  default     = true
}

variable "cleanup_on_fail" {
  description = "Cleanup the release if it fails"
  type        = bool
  default     = true
}
