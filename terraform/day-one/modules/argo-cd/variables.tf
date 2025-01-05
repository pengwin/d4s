variable "chart_version" {
  description = "The version of the argo-cd chart to install"
  type        = string
  default     = "7.0.0"
}

variable "namespace" {
  description = "The namespace to install the argo-cd controller into"
  type        = string
  default     = "argo-cd"
}

variable "release_name" {
  description = "The name of the helm release"
  type        = string
  default     = "argo-cd"
}

variable "argo_domain" {
  description = "The DNS name for the Argo CD server"
  type        = string
  default     = "argocd.test-kubernetes"
}

variable "cluster_issuer_name" {
  description = "The name of the cert-manager cluster issuer"
  type        = string
}
