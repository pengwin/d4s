include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "../../terraform/kubernetes-ca"
}

inputs = {
  common_name           = include.env.locals.cluster_name
  country               = "RS"
  city                  = "Belgrade"
  company               = "Test K8S"
  validity_period_hours = 24 * 365
}