user_name := "vagrant_admin"
cluster_name := "test-kubernetes"
fetched_kubeconfig := replace("ansible/fetched/control-plane-master/home/vagrant/${user_name}.conf", "${user_name}", user_name)
kubeconfig := ".kube/config"

up: day-one
    #!/usr/bin/env bash
    cluster_ip="$(just get-cluster-ip)"
    echo "Cluster is up on $cluster_ip."
    echo "Configure KUBECONFIG to access the cluster:"
    echo "export KUBECONFIG={{kubeconfig}}"
    echo "To access the docker registry, add the following line to /etc/hosts:"
    echo "127.0.0.1 docker-registry.docker-registry.svc.cluster.local"
    echo "Add ca cert to trusted storage"
    echo "just extract-ca-cert | sudo tee /etc/ssl/certs/test-cluster-ca.crt"
    echo "sudo openssl x509 -in /etc/ssl/certs/test-cluster-ca.crt -out /etc/ssl/certs/test-cluster-ca.pem -outform PEM"
    echo "sudo chmod 644 /etc/ssl/certs/test-cluster-ca.pem"
    echo "sudo update-ca-certificates"
    echo "Forward ingress nginx to localhost"
    echo "sudo KUBECONFIG={{kubeconfig}} kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 443:https"

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
    KUBECONFIG={{kubeconfig}} kubectl get nodes -o jsonpath='{.items[?(@.metadata.name=="control-plane-master")].status.addresses[?(@.type=="InternalIP")].address}'

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
    KUBECONFIG={{kubeconfig}} kubectl get secret ca-cert --namespace cert-manager -o jsonpath='{.data.tls\.crt}' | base64 -d

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

cluster-shell:
    KUBECONFIG={{kubeconfig}} kubectl run -i --tty --rm just-shell --image=apline --restart=Never -- /bin/sh

default_just_command :="just"

proxy-nginx just_command=default_just_command:
    {{just_command}} extract-ca-cert | tee /etc/ssl/certs/test-cluster-ca.crt
    openssl x509 -in /etc/ssl/certs/test-cluster-ca.crt -out /etc/ssl/certs/test-cluster-ca.pem -outform PEM
    chmod 644 /etc/ssl/certs/test-cluster-ca.pem
    sudo update-ca-certificates
    KUBECONFIG={{kubeconfig}} kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 443:https

