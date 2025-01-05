locals {
  repo_dir = "${var.repo_path}/hello-world-deploy"
  push_url = var.hello_world_deploy_push_url
}

resource "git_init" "hello_world_deploy" {
  directory = local.repo_dir
}

resource "local_file" "hello_world_deploy_chart" {
  content = <<EOF
apiVersion: v2
name: hello-world-deploy
description: A Helm chart for Kubernetes
type: application
version: 0.0.1
appVersion: 0.0.1
EOF

  filename = "${local.repo_dir}/Chart.yaml"

  depends_on = [git_init.hello_world_deploy]
}

resource "git_add" "hello_world_deploy_chart" {
  directory = local.repo_dir
  add_paths = ["Chart.yaml"]

  depends_on = [local_file.hello_world_deploy_chart]
}

resource "git_commit" "commit" {
  directory = local.repo_dir
  message   = "by-terraform: Add Chart.yaml"
  author    = {
    name  = "Terraform"
    email = "terraform@test-kubernetes"
  }
  provisioner "local-exec" {
    command     = "git -c http.sslVerify=false push --set-upstream ${local.push_url} master" 
    working_dir = local.repo_dir
  }
}

/*resource "git_push" "remote" {
  directory = local.repo_dir
  refspecs  = ["refs/heads/master:refs/heads/master"]

  auth = {
    ssh_key = {
      username        = "git"
      private_key_pem = tls_private_key.hello_world_init.private_key_openssh
    }
  }

  depends_on = [git_commit.commit, gitea_repository_key.hello_world_init_key]
}*/



