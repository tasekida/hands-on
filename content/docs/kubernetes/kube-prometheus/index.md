---
weight: 4
title: "kube-prometheus"
date: 2022-08-26T00:00:00+09:00
---
# kube-prometheus
## 準備
#### [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)を取得
```tpl
mkdir my-kube-prometheus; cd my-kube-prometheus
jb init
jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
wget https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/build.sh -O build.sh
chmod 0755 build.sh
```
---
#### 自分用にカスタマイズ
- ここでは事前に用意していた自分用にカスタマイズ済みのファイルを使います。
```tpl
wget https://www.oblique-rays.cyou/docs/kubernetes/kube-prometheus/original.jsonnet -O original.jsonnet
./build.sh original.jsonnet
```
---
#### インストール
```tpl
kubectl apply --server-side -f manifests/setup
kubectl apply -f manifests/
```
---
#### LoadBalancerの設定
```tpl
kubectl patch svc grafana -n monitoring -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc prometheus-k8s -n monitoring -p '{"spec": {"type": "LoadBalancer"}}'
```
---
#### 確認
```tpl
kubectl get all,cm,ing,pvc,pv,storageclass,secret,networkpolicies -n monitoring
```