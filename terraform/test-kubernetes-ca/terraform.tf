terraform {
  required_version = ">= 1.10"

  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
