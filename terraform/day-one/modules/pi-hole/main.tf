resource "helm_release" "pi-hole" {
  name = var.release_name

  chart = "${path.module}/chart"

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60*2
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      pi_hole_password = var.pi_hole_password
    })
  ]
}
