module "ingress_nginx" {
  source = "./modules/ingress-nginx"

  namespace = "ingress-nginx"
  chart_version = "4.11.3"
  release_name = "ingress-nginx"
}
