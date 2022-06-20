---
weight: 3
title: "argocd"
date: 2022-06-20T23:00:00+09:00
---
# Argo CD
## 設定
- kubesprayでインストールは完了しているので設定をします。
#### LoadBalancerの設定
- argocd-serverのサービスタイプをLoadBalancerに設定してクラスター外部からアクセス出来るようにします。
```tpl
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
---
#### argocd-serverのパスワードを設定
- 初期パスワードを取得    
```tpl
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
- 初期パスワードでログイン    
```tpl
argocd login <service/argocd-serverのEXTERNAL-IP>
Username: admin
Password: <先ほど取得したパスワード>
```
- パスワードを変更    
```tpl
argocd account update-password
```
