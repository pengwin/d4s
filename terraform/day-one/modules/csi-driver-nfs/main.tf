resource "helm_release" "csi-driver-nfs" {
  name = var.release_name

  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart      = "csi-driver-nfs"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          kind = "daemonset"
          type = "NodePort"
        }
      }
    })
  ]
}
