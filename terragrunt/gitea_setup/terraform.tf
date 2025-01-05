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
  }
}
