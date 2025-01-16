locals {
  project_name = "hello-world"
  app_name     = "hello-world-helm"
  namespace    = "hello-world"
}

resource "argocd_project" "hello-world" {
  metadata {
    name = local.project_name
  }

  spec {
    description = "Hello World Project"

    source_repos      = [var.hello_world_deploy_ssh]
    source_namespaces = [local.namespace]

    destination {
      name      = "in-cluster"
      namespace = local.namespace
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_application" "hello_world" {
  metadata {
    name = local.app_name
  }

  spec {

    project = local.project_name

    destination {
      name      = "in-cluster"
      namespace = local.namespace
    }

    source {
      repo_url = var.hello_world_deploy_ssh
      helm {
        release_name = "hello-world-helm"
      }
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = false
      }
      sync_options = ["CreateNamespace=true"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }

  depends_on = [argocd_project.hello-world]
}

resource "argocd_repository" "hello_world_deploy" {
  repo            = var.hello_world_deploy_ssh
  project         = local.project_name
  username        = "git"
  ssh_private_key = var.argocd_deploy_private_key
  insecure        = true
}




