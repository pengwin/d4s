terraform {
  required_version = ">= 1.10"

  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.1.0"
    }
  }
}
