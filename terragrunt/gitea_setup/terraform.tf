terraform {
  required_version = ">= 1.10"

  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
    gitea = {
      source = "go-gitea/gitea"
      version = "0.5.1"
    }
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
