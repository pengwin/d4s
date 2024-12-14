kubceconfig := "ansible/fetched/control-plane/etc/kubernetes/admin.conf"

up: day-one

day-one: nodes-up
    ansible-playbook ./ansible/day_one_playbook.yaml

nodes-up: ansible-lint
    just vms/kube-vm/vm-up

# Utility targets

nodes:
    KUBECONFIG={{kubceconfig}} kubectl get nodes -o wide

all-pods:
    KUBECONFIG={{kubceconfig}} kubectl get pods --all-namespaces

clean:
    just vms/kube-vm/clean

install-hello-world:
    KUBECONFIG={{kubceconfig}} helm install hello-world ./workload/hello-world/chart

uninstall-hello-world:
    KUBECONFIG={{kubceconfig}} helm uninstall hello-world

lint: ansible-lint

ansible-lint:
    just ansible/lint

