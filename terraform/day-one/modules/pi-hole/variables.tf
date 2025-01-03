variable "chart_version" {
  description = "The version of pi-hole chart to install"
  type        = string
  default     = "0.0.1"
}

variable "namespace" {
  description = "The namespace to install the pi-hole dns into"
  type        = string
  default     = "pi-hole"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "pi-hole"
}

variable "pi_hole_password" {
  description = "The password for the pi-hole web interface"
  type        = string
  default     = "12345"
}
