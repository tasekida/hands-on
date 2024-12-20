---
weight: 1
title: "kubespray"
date: 2023-01-20T23:00:00+09:00
---
# kubespray
## 準備
#### Kubesprayを取得
- githubから[Kubespray](https://github.com/kubernetes-sigs/kubespray)を取得します。
```tpl
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git reset --hard c4346e590f12239fe9f597cebdb00b5c0ffdc7b3
cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(192.168.51.1 192.168.51.2 192.168.51.3 192.168.51.4)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
sudo pip install -r requirements-2.12.txt
```
---
#### 構成情報を設定  
- inventory/mycluster/hosts.yaml  
{{< tabs "hosts" >}}
{{< tab "AS-IS" "hosts-as-is" >}}
```tpl
all:
  hosts:
    node1:
      ansible_host: 192.168.51.1
      ip: 192.168.51.1
      access_ip: 192.168.51.1
    node2:
      ansible_host: 192.168.51.2
      ip: 192.168.51.2
      access_ip: 192.168.51.2
    node3:
      ansible_host: 192.168.51.3
      ip: 192.168.51.3
      access_ip: 192.168.51.3
    node4:
      ansible_host: 192.168.51.4
      ip: 192.168.51.4
      access_ip: 192.168.51.4
  children:
    kube_control_plane:
      hosts:
        node1:
        node2:
    kube_node:
      hosts:
        node1:
        node2:
        node3:
        node4:
    etcd:
      hosts:
        node1:
        node2:
        node3:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```
{{< /tab >}}
{{< tab "TO-BE" "hosts-to-be" >}}
```tpl
all:
  hosts:
    k8smaster01:
      ansible_host: 192.168.51.1
      ip: 192.168.51.1
      access_ip: 192.168.51.1
    k8sworker01:
      ansible_host: 192.168.51.2
      ip: 192.168.51.2
      access_ip: 192.168.51.2
    k8sworker02:
      ansible_host: 192.168.51.3
      ip: 192.168.51.3
      access_ip: 192.168.51.3
    k8sworker03:
      ansible_host: 192.168.51.4
      ip: 192.168.51.4
      access_ip: 192.168.51.4
  children:
    kube_control_plane:
      hosts:
        k8smaster01:
    kube_node:
      hosts:
        k8sworker01:
        k8sworker02:
        k8sworker03:
    etcd:
      hosts:
        k8smaster01:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```
{{< /tab >}}
{{< /tabs >}}
#### Cluster全体の設定  
- inventory/mycluster/group_vars/all/all.yml  
{{< tabs "all" >}}
{{< tab "AS-IS" "all-as-is" >}}
```tpl
## Upstream dns servers
# upstream_dns_servers:
#   - 8.8.8.8
#   - 8.8.4.4

## NTP Settings
# Start the ntpd or chrony service and enable it at system boot.
ntp_enabled: false
ntp_manage_config: false
ntp_servers:
  - "0.pool.ntp.org iburst"
  - "1.pool.ntp.org iburst"
  - "2.pool.ntp.org iburst"
  - "3.pool.ntp.org iburst"
```
{{< /tab >}}
{{< tab "TO-BE" "all-to-be" >}}
```tpl
## Upstream dns servers
upstream_dns_servers:
  - 8.8.8.8
  - 1.1.1.1

## NTP Settings
# Start the ntpd or chrony service and enable it at system boot.
ntp_enabled: true
ntp_manage_config: true
ntp_servers:
  - "0.jp.pool.ntp.org iburst"
  - "1.jp.pool.ntp.org iburst"
  - "2.jp.pool.ntp.org iburst"
  - "3.jp.pool.ntp.org iburst"
```
{{< /tab >}}
{{< /tabs >}}
#### Containerdの設定  
- inventory/mycluster/group_vars/all/containerd.yml  
{{< tabs "containerd" >}}
{{< tab "AS-IS" "containerd-as-is" >}}
```tpl
# containerd_registries:
#   "docker.io": "https://registry-1.docker.io"
```
{{< /tab >}}
{{< tab "TO-BE" "containerd-to-be" >}}
```tpl
containerd_registries:
  "docker.io":
    - "https://mirror.gcr.io"
    - "https://registry-1.docker.io"
```
{{< /tab >}}
{{< /tabs >}}
#### K8s Addonの設定  
- inventory/mycluster/group_vars/k8s_cluster/addons.yml  
{{< tabs "addons" >}}
{{< tab "AS-IS" "addons-as-is" >}}
```tpl
# Helm deployment
helm_enabled: false

# csi_snapshot_controller_enabled: false
# csi snapshot namespace
# snapshot_controller_namespace: kube-system

# Nginx ingress controller deployment
ingress_nginx_enabled: false

# Cert manager deployment
cert_manager_enabled: false

# MetalLB deployment
metallb_enabled: false
metallb_speaker_enabled: true
# metallb_ip_range:
#   - "10.5.0.50-10.5.0.99"
# metallb_pool_name: "loadbalanced"
# matallb_auto_assign: true
# metallb_speaker_nodeselector:
#   kubernetes.io/os: "linux"
# metallb_controller_nodeselector:
#   kubernetes.io/os: "linux"
# metallb_speaker_tolerations:
#   - key: "node-role.kubernetes.io/master"
#     operator: "Equal"
#     value: ""
#     effect: "NoSchedule"
#   - key: "node-role.kubernetes.io/control-plane"
#     operator: "Equal"
#     value: ""
#     effect: "NoSchedule"
# metallb_controller_tolerations:
#   - key: "node-role.kubernetes.io/master"
#     operator: "Equal"
#     value: ""
#     effect: "NoSchedule"
#   - key: "node-role.kubernetes.io/control-plane"
#     operator: "Equal"
#     value: ""
#     effect: "NoSchedule"
# metallb_version: v0.12.1
# metallb_protocol: "layer2"
# metallb_port: "7472"
# metallb_memberlist_port: "7946"
# metallb_additional_address_pools:
#   kube_service_pool:
#     ip_range:
#       - "10.5.1.50-10.5.1.99"
#     protocol: "layer2"
#     auto_assign: false
# metallb_protocol: "bgp"
# metallb_peers:
#   - peer_address: 192.0.2.1
#     peer_asn: 64512
#     my_asn: 4200000000
#   - peer_address: 192.0.2.2
#     peer_asn: 64513
#     my_asn: 4200000000

argocd_enabled: false
```
{{< /tab >}}
{{< tab "TO-BE" "addons-to-be" >}}
```tpl
# Helm deployment
helm_enabled: true

csi_snapshot_controller_enabled: true
# csi snapshot namespace
snapshot_controller_namespace: synology-csi

# Nginx ingress controller deployment
ingress_nginx_enabled: true

# Cert manager deployment
cert_manager_enabled: true

# MetalLB deployment
metallb_enabled: true
metallb_speaker_enabled: true
metallb_ip_range:
  - "192.168.51.128/26"
metallb_pool_name: "k8scluster01"
metallb_auto_assign: true
# metallb_speaker_nodeselector:
#   kubernetes.io/os: "linux"
# metallb_controller_nodeselector:
#   kubernetes.io/os: "linux"
metallb_speaker_tolerations:
  - key: "node-role.kubernetes.io/master"
    operator: "Equal"
    value: ""
    effect: "NoSchedule"
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Equal"
    value: ""
    effect: "NoSchedule"
metallb_controller_tolerations:
  - key: "node-role.kubernetes.io/master"
    operator: "Equal"
    value: ""
    effect: "NoSchedule"
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Equal"
    value: ""
    effect: "NoSchedule"
# metallb_version: v0.12.1
# metallb_protocol: "layer2"
# metallb_port: "7472"
# metallb_memberlist_port: "7946"
# metallb_additional_address_pools:
#   kube_service_pool:
#     ip_range:
#       - "10.5.1.50-10.5.1.99"
#     protocol: "layer2"
#     auto_assign: false
metallb_protocol: "bgp"
metallb_peers:
  - peer_address: 192.168.51.254
    peer_asn: 65001
    my_asn: 65002
#   - peer_address: 192.0.2.2
#     peer_asn: 64513
#     my_asn: 4200000000

argocd_enabled: true
```
{{< /tab >}}
{{< /tabs >}}
#### K8s Clusterの設定  
- inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml  
{{< tabs "k8s-cluster" >}}
{{< tab "AS-IS" "k8s-cluster-as-is" >}}
```tpl
# configure arp_ignore and arp_announce to avoid answering ARP queries from kube-ipvs0 interface
# must be set to true for MetalLB to work
kube_proxy_strict_arp: false

# Make a copy of kubeconfig on the host that runs Ansible in {{ inventory_dir }}/artifacts
# kubeconfig_localhost: false
# Use ansible_host as external api ip when copying over kubeconfig.
# kubeconfig_localhost_ansible_host: false
# Download kubectl onto the host that runs Ansible in {{ bin_dir }}
# kubectl_localhost: false
```
{{< /tab >}}
{{< tab "TO-BE" "k8s-cluster-to-be" >}}
```tpl
# configure arp_ignore and arp_announce to avoid answering ARP queries from kube-ipvs0 interface
# must be set to true for MetalLB to work
kube_proxy_strict_arp: true

# Make a copy of kubeconfig on the host that runs Ansible in {{ inventory_dir }}/artifacts
kubeconfig_localhost: true
# Use ansible_host as external api ip when copying over kubeconfig.
kubeconfig_localhost_ansible_host: true
# Download kubectl onto the host that runs Ansible in {{ bin_dir }}
kubectl_localhost: true
```
{{< /tab >}}
{{< /tabs >}}
#### K8s Clusterの設定  
- inventory/mycluster/group_vars/k8s_cluster/k8s-net-calico.yml  
{{< tabs "k8s-net-calico" >}}
{{< tab "AS-IS" "k8s-net-calico-as-is" >}}
```tpl
# Adveritse Service LoadBalancer IPs
# calico_advertise_service_loadbalancer_ips:
# - x.x.x.x/24
# - y.y.y.y/16

# Choose Calico iptables backend: "Legacy", "Auto" or "NFT"
# calico_iptables_backend: "Auto"
```
{{< /tab >}}
{{< tab "TO-BE" "k8s-net-calico-to-be" >}}
```tpl
# Adveritse Service LoadBalancer IPs
calico_advertise_service_loadbalancer_ips:
- 192.168.51.128/26
# - y.y.y.y/16

# Choose Calico iptables backend: "Legacy", "Auto" or "NFT"
calico_iptables_backend: "NFT"
```
{{< /tab >}}
{{< /tabs >}}
---
#### Kubesprayを実行
- Kubesprayを実行します。
```tpl
sudo ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml --become --become-user=root -v --private-key=~/.ssh/k8scluster.pem
```
---
#### kubectlを設定
- kubectlを設定します。
```tpl
mkdir -p ~/.kube
sudo cp inventory/mycluster/artifacts/kubectl /usr/local/bin/kubectl
sudo cp inventory/mycluster/artifacts/admin.conf ~/.kube/config
kubectl get node -o wide
kubectl get all,cm,ing,pvc,pv,storageclass,secret,networkpolicies --all-namespaces -o wide
```