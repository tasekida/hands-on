---
weight: 2
title: "synology-csi"
date: 2023-01-29T23:00:00+09:00
---
# synology-csi
  
## 準備
#### [CSI Driver](https://kubernetes-csi.github.io/docs/drivers.html)を取得
- githubから[Synology CSI Driver for Kubernetes](https://github.com/SynologyOpenSource/synology-csi)を取得します。
```tpl
git clone https://github.com/SynologyOpenSource/synology-csi
cd synology-csi
cp config/client-info-template.yml config/client-info.yml
```
---
#### Synology DS220+ への接続情報を設定  
- config/client-info.yml  
{{< tabs "client-info" >}}
{{< tab "AS-IS" "client-info-as-is" >}}
```tpl
---
clients:
  - host: 192.168.1.1
    port: 5000
    https: false
    username: username
    password: password
  - host: 192.168.1.2
    port: 5000
    https: false
    username: username
    password: password
```
{{< /tab >}}
{{< tab "TO-BE" "client-info-to-be" >}}
```tpl
---
clients:
  - host: 192.168.50.xxx (Synology DS220+ のIPアドレス)
    port: 5001
    https: true
    username: xxxxxxxxxx (Synology DS220+ のユーザー)
    password: xxxxxxxxxx (Synology DS220+ のパスワード)
```
{{< /tab >}}
{{< /tabs >}}
#### StrageClassの情報を設定  
- deploy/kubernetes/v1.20/storage-class.yml  
{{< tabs "storage-class" >}}
{{< tab "AS-IS" "storage-class-as-is" >}}
```tpl
metadata:
  name: synology-iscsi-storage
  # annotations:
  #   storageclass.kubernetes.io/is-default-class: "true"
provisioner: csi.san.synology.com
# if all params are empty, synology CSI will choose an available location to create volume
# parameters:
#   dsm: '1.1.1.1'
#   location: '/volume1'
#   fsType: 'ext4'
reclaimPolicy: Retain
allowVolumeExpansion: true
```
{{< /tab >}}
{{< tab "TO-BE" "storage-class-to-be" >}}
```tpl
metadata:
  name: synology-iscsi-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: csi.san.synology.com
# if all params are empty, synology CSI will choose an available location to create volume
parameters:
  dsm: '192.168.50.xxx' (Synology DS220+ のIPアドレス)
  location: '/volume3' (Synology DS220+ に作成したCluster専用のVolume)
  fsType: 'ext4' (ClusterからVolumeをマウントする時のファイルシステム)
reclaimPolicy: Retain
allowVolumeExpansion: true
```
{{< /tab >}}
{{< /tabs >}}
#### VolumeSnapshotClassesの情報を設定  
- deploy/kubernetes/v1.20/snapshotter/volume-snapshot-class.yml  
{{< tabs "volume-snapshot-class" >}}
{{< tab "AS-IS" "volume-snapshot-class-as-is" >}}
```tpl
metadata:
  name: synology-snapshotclass
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
driver: csi.san.synology.com
deletionPolicy: Delete
```
{{< /tab >}}
{{< tab "TO-BE" "volume-snapshot-class-to-be" >}}
```tpl
metadata:
  name: synology-snapshotclass
  namespace: synology-csi
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
driver: csi.san.synology.com
deletionPolicy: Delete
```
{{< /tab >}}
{{< /tabs >}}
---
## インストール
#### Synology CSI Driver for Kubernetesをビルド
- Synology CSI Driver for Kubernetesをビルドします。
```tpl
./scripts/deploy.sh build
```
#### Synology CSI Driver for Kubernetesをインストール
- Synology CSI Driver for Kubernetesをインストールします。
```tpl
./scripts/deploy.sh install --all
```
