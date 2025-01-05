variable "gitea_domain" {
  description = "The domain where gitea is available"
  type        = string
}

variable "gitea_admin_username" {
  description = "The username of the gitea admin"
  type        = string
}

variable "gitea_admin_password" {
  description = "The password of the gitea admin"
  type        = string
}

variable "repo_path" {
  description = "The path to the repository"
  type = string
}