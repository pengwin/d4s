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
        name = "webhook"
        webhook = {
          image = {
            repository = "docker-registry.test-kubernetes/dns-server-webhook"
            tag        = "0.0.1"
            pullPolicy = "Always"
          }
          env = [
            {
              name  = "DNS_WEBHOOK_EXPOSED_ENDPOINT"
              value = "0.0.0.0:8080"
            },
            {
              name  = "DNS_WEBHOOK_INTERNAL_ENDPOINT"
              value = "127.0.0.1:8888"
            },
            {
              name  = "DNS_DNS_SERVER"
              value = "http://lab-dns.lab-dns.svc.cluster.local"
          }]
        }
      }
    })
  ]
}
