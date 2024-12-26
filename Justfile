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

get-cluster-ip:
    #!/usr/bin/env bash
    kubectl get nodes -o jsonpath='{.items[?(@.metadata.name=="control-plane")].status.addresses[?(@.type=="InternalIP")].address}'

get-docker-port:
    #!/usr/bin/env bash
    kubectl get svc docker-registry --namespace docker-registry -o jsonpath='{.spec.ports[?(@.name=="http-5000")].nodePort}'

get-docker-registry:
    #!/usr/bin/env bash
    cluster_ip="$(just get-cluster-ip)"
    docker_reg_port="$(just get-docker-port)"
    echo $cluster_ip:$docker_reg_port

extract-ca-cert:
    #!/usr/bin/env bash
    kubectl get secret ca-cert --namespace cert-manager -o jsonpath='{.data.tls\.crt}' | base64 -d

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

