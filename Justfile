kubceconfig := "ansible/fetched/control-plane/etc/kubernetes/admin.conf"

up: day-one

day-one: control-plane worker-node-red-up worker-node-blue-up
    ansible-playbook ./ansible/day_one_playbook.yaml

control-plane: control-plane-up
    ansible-playbook ./ansible/networking_playbook.yaml

control-plane-up:
    just vms/control-plane/vm-up

worker-node-red-up:
    just vms/worker-node-red/vm-up

worker-node-blue-up:
    just vms/worker-node-blue/vm-up

# Utility targets

nodes:
    KUBECONFIG={{kubceconfig}} kubectl get nodes -o wide

clean:
    just vms/control-plane/clean
    just vms/worker-node-red/clean
    just vms/worker-node-blue/clean

install-hello-world:
    KUBECONFIG={{kubceconfig}} helm install hello-world ./workload/hello-world/chart

uninstall-hello-world:
    KUBECONFIG={{kubceconfig}} helm uninstall hello-world


