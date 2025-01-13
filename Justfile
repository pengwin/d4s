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
    echo "Add CA cert to trusted storage"
    echo "just update-ca-cert"
    echo "Add CA cert to chrome"
    echo "just update-chrome-certs"

terragrunt: fmt
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

clean:
    just terragrunt/clean
    just ansible/clean
    rm -v -rf ./.kube
    rm -v -rf ./.certs

delete-pvc:
    sudo rm -rf /srv/nfs/k8s_csi/pvc-*

# Service targets

update-ca-cert:
    #!/usr/bin/env bash
    current_dir="$(pwd)"
    ca_cert_fullpath="$current_dir/{{ca_cert}}"
    ansible-playbook --connection=local --ask-become-pass  ansible/local_ca_install_playbook.yaml -e ca_cert_path=$ca_cert_fullpath
    diff $ca_cert_fullpath /etc/ssl/certs/test-cluster-ca.pem

docker-login:
    docker login docker-registry.test-kubernetes -u '' -p ''
    
update-chrome-certs:
    certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "test-kubernetes" -i .certs/ca.crt

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

push-hello-world-container:
    just workload/hello-world/app/docker-push

install-hello-world: push-hello-world-container uninstall-hello-world
    KUBECONFIG={{kubeconfig}} helm install --namespace hello --create-namespace hello-world ./workload/hello-world/chart

uninstall-hello-world:
    KUBECONFIG={{kubeconfig}} helm uninstall --namespace hello hello-world --ignore-not-found

prepare-hello-world-repo:
    #!/usr/bin/env bash
    chart_repo="$(find ./terragrunt/k8s/workload/gitea-create-repos/ -type d -name 'hello-world-deploy')"
    cp -rv ./workload/hello-world/chart/* $chart_repo
    code $chart_repo

lint: ansible-lint terraform-lint

fmt:
    just terragrunt/fmt

ansible-lint:
    just ansible/lint

terraform-lint:
    just terraform/lint

cluster-shell:
    KUBECONFIG={{kubeconfig}} kubectl run -i --tty --rm just-shell --image=docker.io/library/alpine:3.21 --restart=Never -- /bin/sh


argocd-admin:
    echo "ArgoCD username: admin password:"
    @KUBECONFIG={{kubeconfig}} kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

gitea-admin:
    @echo "Gitea username:"
    @KUBECONFIG={{kubeconfig}} kubectl -n gitea get secret gitea-admin -o jsonpath="{.data.username}" | base64 -d
    @echo ""
    @echo "Gitea password:"
    @KUBECONFIG={{kubeconfig}} kubectl -n gitea get secret gitea-admin -o jsonpath="{.data.password}" | base64 -d

pi-hole-admin:
    @echo "Pi-hole password:"
    @KUBECONFIG={{kubeconfig}} kubectl -n external-dns get secret pi-hole-web-password -o jsonpath="{.data.password}" | base64 -d

gitea-repo:
    @just terragrunt/print-sensitive ./gitea_setup hello_world_deploy_clone_url
    



