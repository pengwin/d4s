user_name := "vagrant_admin"
cluster_name := "test-kubernetes"
fetched_kubeconfig := replace("ansible/fetched/control-plane-master/home/vagrant/${user_name}.conf", "${user_name}", user_name)
kubeconfig := ".kube/config"

up: day-one

day-one: copy-kubeconfig
    just terraform/day-one

copy-kubeconfig: nodes-up
    mkdir -p .kube
    cp {{fetched_kubeconfig}} {{kubeconfig}}

nodes-up: ansible-lint
    just vms/kube-vm/vm-up {{user_name}} {{cluster_name}}


# Utility targets

get-cluster-url:
    #!/usr/bin/env bash
    cluster_url="$(kubectl --kubeconfig {{kubeconfig}} config view -o jsonpath='{.clusters[0].cluster.server}')"
    echo $cluster_url

nodes:
    KUBECONFIG={{kubeconfig}} kubectl get nodes --output=wide

all-pods:
    KUBECONFIG={{kubeconfig}} kubectl get pods --all-namespaces --output=wide

clean:
    just vms/kube-vm/clean
    just terraform/clean
    just ansible/clean
    rm -rf .kube

install-hello-world:
    KUBECONFIG={{kubeconfig}} helm install hello-world ./workload/hello-world/chart

uninstall-hello-world:
    KUBECONFIG={{kubeconfig}} helm uninstall hello-world

lint: ansible-lint

ansible-lint:
    just ansible/lint

