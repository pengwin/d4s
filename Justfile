user_name := "vagrant_admin"
cluster_name := "test-kubernetes"
fetched_kubeconfig := replace("ansible/fetched/control-plane-master/home/vagrant/${user_name}.conf", "${user_name}", user_name)
kubeconfig := ".kube/config"

# CA files
ca_key := ".certs/ca.key"
ca_cert := ".certs/ca.crt"

# Start the cluster

up: day-one
    #!/usr/bin/env bash
    cluster_ip="$(just get-cluster-ip)"
    just_path="$(which just)"
    echo "Cluster is up on $cluster_ip."
    echo "Configure KUBECONFIG to access the cluster:"
    echo "export KUBECONFIG={{kubeconfig}}"
    echo "To access the docker registry, add the following line to /etc/hosts:"
    echo "$cluster_ip docker-registry.test-kubernetes"
    echo "Add ca cert to trusted storage"
    echo "sudo $just_path update-ca-cert $just_path"

day-one: copy-kubeconfig
    #!/usr/bin/env bash
    cluster_ip="$(just get-cluster-ip)"
    current_dir="$(pwd)"
    ca_key_fullpath="$current_dir/{{ca_key}}"
    ca_cert_fullpath="$current_dir/{{ca_cert}}"
    kubeconfig_fullpath="$current_dir/{{kubeconfig}}"
    just terraform/day-one $cluster_ip $ca_key_fullpath $ca_cert_fullpath $kubeconfig_fullpath

copy-kubeconfig: nodes-up
    mkdir -p .kube
    cp {{fetched_kubeconfig}} {{kubeconfig}}

nodes-up: test_kubernetes_ca lint
    #!/usr/bin/env bash
    current_dir="$(pwd)"
    ca_cert_fullpath="$current_dir/{{ca_cert}}"
    just vms/kube-vm/vm-up {{user_name}} {{cluster_name}} $ca_cert_fullpath

test_kubernetes_ca:
    #!/usr/bin/env bash
    current_dir="$(pwd)"
    ca_key_fullpath="$current_dir/{{ca_key}}"
    ca_cert_fullpath="$current_dir/{{ca_cert}}"
    just terraform/test_kubernetes_ca $ca_key_fullpath $ca_cert_fullpath

# Stop the cluster

down:
    just vms/kube-vm/clean
    just terraform/clean
    just ansible/clean
    rm -rf .kube

# Utility targets

get-cluster-ip:
    #!/usr/bin/env bash
    KUBECONFIG={{kubeconfig}} kubectl get nodes -o jsonpath='{.items[?(@.metadata.name=="control-plane-master")].status.addresses[?(@.type=="InternalIP")].address}'

nodes:
    KUBECONFIG={{kubeconfig}} kubectl get nodes --output=wide

all-pods:
    KUBECONFIG={{kubeconfig}} kubectl get pods --all-namespaces --output=wide

install-hello-world:
    KUBECONFIG={{kubeconfig}} helm install hello-world ./workload/hello-world/chart

uninstall-hello-world:
    KUBECONFIG={{kubeconfig}} helm uninstall hello-world

lint: ansible-lint terraform-lint

ansible-lint:
    just ansible/lint

terraform-lint:
    just terraform/lint

cluster-shell:
    KUBECONFIG={{kubeconfig}} kubectl run -i --tty --rm just-shell --image=docker.io/library/alpine:3.21 --restart=Never -- /bin/sh

default_just_command :="just"

update-ca-cert just_command=default_just_command:
    #!/usr/bin/env bash
    current_dir="$(pwd)"
    echo $current_dir
    ca_cert_fullpath="$current_dir/{{ca_cert}}"
    openssl x509 -in $ca_cert_fullpath -out /etc/ssl/certs/test-cluster-ca.pem -outform PEM
    chmod 644 /etc/ssl/certs/test-cluster-ca.pem
    update-ca-certificates

