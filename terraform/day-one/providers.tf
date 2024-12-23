provider "helm" {
  kubernetes {
    config_path = "../../.kube/config"
  }

  # localhost registry with password protection
  #registry {
  #  url = "oci://localhost:5000"
  #  username = "username"
 #   password = "password"
 # }

}
