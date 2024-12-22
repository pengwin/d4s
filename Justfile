user_name := "vagrant_admin"
cluster_name := "test-kubernetes"
kubceconfig := replace("ansible/fetched/control-plane-master/home/vagrant/${user_name}.conf", "${user_name}", user_name)

up: day-one

day-one: nodes-up
    ansible-playbook ./ansible/day_one_playbook.yaml --extra-vars "cluster_name={{cluster_name}} username={{user_name}}"

nodes-up: ansible-lint
    just vms/kube-vm/vm-up {{user_name}} {{cluster_name}}

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

