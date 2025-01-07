terraform {
  required_version = ">= 1.10"

  required_providers {
    git = {
      source = "metio/git"
      version = "2025.1.3"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
