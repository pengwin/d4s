kubeconfig := ".kube/config"

# CA files
ca_key := ".certs/ca.key"
ca_cert := ".certs/ca.crt"

# Start the cluster

up: terragrunt
    #!/usr/bin/env bash
    cluster_ip="$(just get-cluster-ip)"
    echo "Cluster is up on $cluster_ip."
    echo "Configure KUBECONFIG to access the cluster:"
    echo "export KUBECONFIG={{kubeconfig}}"
    echo "To access the docker registry, add the following line to /etc/hosts:"
    echo "$cluster_ip docker-registry.test-kubernetes"
    echo "Add ca cert to trusted storage"
    echo "just update-ca-cert"

terragrunt: 
    just terragrunt/apply

lab-dns: apply-lab-dns
    echo "sudo resolvectl dns virbr1 172.16.122.13 1.1.1.1 8.8.8.8"
    echo "resolvectl domain virbr1 test-kubernetes"

apply-lab-dns: install-lab-dns
    #!/usr/bin/env bash
    cluster_ip="$(just get-cluster-ip)"
    current_dir="$(pwd)"
    kubeconfig_fullpath="$current_dir/{{kubeconfig}}"
    just terraform/lab-dns $cluster_ip $kubeconfig_fullpath

install-lab-dns: build-lab-dns
    KUBECONFIG={{kubeconfig}} helm upgrade --install --namespace lab-dns --create-namespace --force lab-dns ./workload/lab-dns/chart

uninstall-lab-dns:
    KUBECONFIG={{kubeconfig}} helm uninstall --namespace lab-dns lab-dns --ignore-not-found

build-lab-dns:
    just workload/lab-dns/build

# Stop the cluster

down:
    just terragrunt/destroy
    rm -rf .kube
    rm -rf .certs

# Service targets

update-ca-cert:
    #!/usr/bin/env bash
    current_dir="$(pwd)"
    ca_cert_fullpath="$current_dir/{{ca_cert}}"
    ansible-playbook --connection=local --ask-become-pass  ansible/local_ca_install_playbook.yaml -e ca_cert_path=$ca_cert_fullpath
    diff $ca_cert_fullpath /etc/ssl/certs/test-cluster-ca.pem

# Utility targets

get-cluster-ip:
    #!/usr/bin/env bash
    KUBECONFIG={{kubeconfig}} kubectl get nodes -o jsonpath='{.items[?(@.metadata.name=="control-plane-master")].status.addresses[?(@.type=="InternalIP")].address}'

get-worker-node-id:
    #!/usr/bin/env bash
    KUBECONFIG={{kubeconfig}} kubectl get nodes -o jsonpath='{.items[?(@.metadata.name=="worker-node-1")].status.addresses[?(@.type=="InternalIP")].address}'

nodes:
    KUBECONFIG={{kubeconfig}} kubectl get nodes --output=wide

all-pods:
    KUBECONFIG={{kubeconfig}} kubectl get pods --all-namespaces --output=wide

test-hello-world:
    KUBECONFIG={{kubeconfig}} helm test --namespace hello hello-world

install-hello-world: uninstall-hello-world
    KUBECONFIG={{kubeconfig}} helm install --namespace hello --create-namespace hello-world ./workload/hello-world/chart

uninstall-hello-world:
    KUBECONFIG={{kubeconfig}} helm uninstall --namespace hello hello-world --ignore-not-found

lint: ansible-lint terraform-lint

ansible-lint:
    just ansible/lint

terraform-lint:
    just terraform/lint

cluster-shell:
    KUBECONFIG={{kubeconfig}} kubectl run -i --tty --rm just-shell --image=docker.io/library/alpine:3.21 --restart=Never -- /bin/sh

docker-login:
    docker login docker-registry.test-kubernetes -u '' -p ''


