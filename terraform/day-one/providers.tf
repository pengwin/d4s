provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_file_path
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_file_path
}
