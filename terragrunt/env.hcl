locals {
  cluster_name      = "test-kubernetes"
  ansible_base_path = "/home/ivan/coding/k8s/ansible"

  ca_key_file_path  = "${get_parent_terragrunt_dir()}/../.certs/ca.key"
  ca_cert_file_path = "${get_parent_terragrunt_dir()}/../.certs/ca.crt"

  kubeconfig_file_path = "${get_parent_terragrunt_dir()}/../.kube/config"

  pi_hole_password = "12345"
}