locals {
  username       = "hello"
  repo_dir       = "${var.repo_path}/hello-world-deploy"
  default_branch = "master"
  push_url       = "https://${local.username}:${urlencode(random_password.user_password.result)}@${var.gitea_domain}/${gitea_org.hello_world_org.name}/${gitea_repository.hello_world_deploy.name}.git"
}

resource "gitea_org" "hello_world_org" {
  name = "hello-world-org"
}

resource "random_password" "user_password" {
  length  = 16
  special = true
}

resource "gitea_user" "user" {
  username             = local.username
  login_name           = local.username
  password             = random_password.user_password.result
  email                = "${local.username}@test-kubernetes.com"
  admin                = true
  must_change_password = false
}

resource "gitea_repository" "hello_world_deploy" {
  username       = gitea_org.hello_world_org.name
  name           = "hello-world-deploy"
  private        = true
  auto_init      = false
  default_branch = local.default_branch
}

resource "tls_private_key" "hello_world_deploy" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "gitea_repository_key" "hello_world_argocd_deploy_key" {
  repository = gitea_repository.hello_world_deploy.id
  title      = "ARGO CD deploy key"
  read_only  = true
  key        = tls_private_key.hello_world_deploy.public_key_openssh
}

output "argocd_deploy_private_key" {
  value     = tls_private_key.hello_world_deploy.private_key_openssh
  sensitive = true
}

output "hello_world_deploy_ssh" {
  value = gitea_repository.hello_world_deploy.ssh_url
}

output "hello_world_deploy_clone_url" {
  value     = "https://${local.username}:${urlencode(random_password.user_password.result)}@${var.gitea_domain}/${gitea_org.hello_world_org.name}/${gitea_repository.hello_world_deploy.name}.git"
  sensitive = true
}

output "hello_world_deploy_push_url" {
  value     = local.push_url
  sensitive = true
}

resource "gitea_team" "hello_world_team" {
  name             = "hello-world-team"
  organisation     = gitea_org.hello_world_org.name
  description      = "Hello World Team"
  permission       = "owner"
  repositories     = [gitea_repository.hello_world_deploy.name]
  can_create_repos = false
}

resource "gitea_team_members" "hello_world_team_members" {
  team_id = gitea_team.hello_world_team.id
  members = [gitea_user.user.username]
}
