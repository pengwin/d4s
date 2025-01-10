module "external-dns" {
  source = "./modules/external-dns"

  namespace     = "external-dns"
  chart_version = "1.15.0"
  release_name  = "external-dns"
}
