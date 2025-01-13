
# Prerequisites

0. [Just](https://just.systems/man/en/pre-built-binaries.html)
1. Install [Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant) 
2. Install qemu and libvirt
```
sudo apt-get install qemu-system-x86 \
libvirt-daemon-system ebtables \
libguestfs-tools ruby-fog-libvirt libvirt-dev
``` 
3. Install libvirt plugin
```
vagrant plugin install vagrant-libvirt
```
https://vagrant-libvirt.github.io/vagrant-libvirt/
4. Configure livirtd
/etc/libvirt/libvirtd.conf
```
# Set the UNIX domain socket group ownership. This can be used to
# allow a 'trusted' set of users access to management capabilities
# without becoming root.
#
# This is restricted to 'root' by default.
unix_sock_group = "libvirtd"

# Set the UNIX socket permissions for the R/O socket. This is used
# for monitoring VM status only
#
# Default allows any user. If setting group ownership, you may want to
# restrict this too.
unix_sock_ro_perms = "0777"

# Set the UNIX socket permissions for the R/W socket. This is used
# for full management of VMs
#
# Default allows only root. If PolicyKit is enabled on the socket,
# the default will change to allow everyone (eg, 0777)
#
# If not using PolicyKit and setting group ownership for access
# control, then you may want to relax this too.
unix_sock_rw_perms = "0770"
```
5. Add user to libvirt group
```
sudo usermod -a -G libvirt <your user>
```
6. [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
7. [Helm](https://helm.sh/docs/intro/install/)
8. [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
7. [k8s module for Ansible](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html) 
```
ansible-galaxy collection install kubernetes.core
```
8. Python kubernetes ```apt-get install python3-kubernetes```

9. Ansible lint ```apt-get install ansible-lint```

10. [Terraform ](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

11. Setup NFS fro CSI

```
sudo apt install nfs-kernel-server
sudo mkdir -p /srv/nfs/k8s_csi
sudo chmod 777 /srv/nfs/k8s_csi
sudo chown nobody:nogroup /srv/nfs/k8s_csi
```
Add to /etc/exports
```
/srv/nfs/k8s_csi 172.16.122.0/24(rw,sync,no_subtree_check)
```
Update config and start service
```
sudo exportfs -arv
sudo systemctl enable nfs-kernel-server
```
12. [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

13. Install libnss-tools to provision ca cert to google chrome
```
sudo apt-get install libnss3-tools`
```

# Usage
1. Provision vagrant nodes
```
just up
```
2. Check nodes
```
just nodes
```
