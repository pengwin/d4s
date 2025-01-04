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
