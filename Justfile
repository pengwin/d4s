kubceconfig := "ansible/fetched/control-plane/etc/kubernetes/admin.conf"

up: day-one

day-one: control-plane-up workers
    ansible-playbook ./ansible/day_one_playbook.yaml

workers: control-plane-up
    just vms/kube-vm/vm-up

control-plane-up:
    just vms/kube-vm/vm-up control-plane

# Utility targets

nodes:
    KUBECONFIG={{kubceconfig}} kubectl get nodes -o wide

clean:
    just vms/kube-vm/clean

install-hello-world:
    KUBECONFIG={{kubceconfig}} helm install hello-world ./workload/hello-world/chart

uninstall-hello-world:
    KUBECONFIG={{kubceconfig}} helm uninstall hello-world


