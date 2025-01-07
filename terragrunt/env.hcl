locals {
  cluster_name      = "test-kubernetes"
  ansible_base_path = "/home/ivan/coding/k8s/ansible"

  vm_network = {
    host_ip = "172.16.122.5"
    nodes = {
      control-plane-master = "172.16.122.10"
      worker-node-1        = "172.16.122.13"
      worker-node-2        = "172.16.122.14"
    }
  }

  ca_key_file_path  = "${get_parent_terragrunt_dir()}/../.certs/ca.key"
  ca_cert_file_path = "${get_parent_terragrunt_dir()}/../.certs/ca.crt"

  kubeconfig_file_path = "${get_parent_terragrunt_dir()}/../.kube/config"

  lb_shared_ip = "shared-ip"

  pi_hole_domain         = "pi-hole.test-kubernetes"
  docker_registry_domain = "docker-registry.test-kubernetes"
  gitea_domain           = "gitea.test-kubernetes"
  argocd_domain          = "argocd.test-kubernetes"
}