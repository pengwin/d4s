resource "helm_release" "external-dns" {
  name = var.release_name

  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  timeout         = 60*3
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      provider = {
        name = "pihole"
      }
      env = [
        {
          name  = "EXTERNAL_DNS_PIHOLE_SERVER"
          value = "http://pi-hole-web.pi-hole.svc.cluster.local"
        },
        {
          name = "EXTERNAL_DNS_PIHOLE_PASSWORD",
          value = var.pi_hole_password
        }
      ]
    })
  ]
}
