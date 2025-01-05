terraform {
  required_version = ">= 1.10"

  required_providers {
    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
