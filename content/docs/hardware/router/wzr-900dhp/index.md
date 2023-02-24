---
weight: 2
title: "WZR-900DHP"
date: 2023-02-24T20:30:00+09:00
---
# WZR-900DHP
## 検討
#### 用途
- iPhone USBテザリングをLANのGatewayとして使う
---
#### 条件
###### USB  
- iPhone USBテザリングを使いたいので
###### 省スペース  
- 設置スペースが狭いので
###### 静音  
- 自宅に設置するので
###### 安価  
- 予算が少ないので
###### 省電力
- 自宅に設置するので
###### OpenWrtサポート
- 日本語情報があり、導入が簡単な機種  
---
#### 候補
###### Buffalo WZR-HP-AG300H  
- 日本語情報が多い
- USB2.0  
###### Buffalo WZR-900DHP  
- 日本語情報がある  
- USB3.0  
###### Buffalo WXR-2533DHP  
- 日本語情報がある  
- USB3.0  
---
## 結果
#### Buffalo WZR-900DHP  
スペックだけ見るとWXR-2533DHPが良かったがデカすぎた。  
USB3.0が欲しかったのでWZR-900DHP。  
- Broadcom BCM47081A0 800MHz 1Core
- Flash 128MB
- RAM 256MB
- USB 3.0 Type-A
- 196×185×28 mm
- 880円
---
## 設定  
#### オリジナルFirmのBackup  
オリジナルのFirmは配布されていないのでBackupが無いとOpenWrtをインストールした後に元に戻せなくなります。  
「http://bufpy:otdpopypassword@192.168.11.1/cgi-bin/cgi?req=frm&frm=py-db/55debug.html」をブラウザで開きます。  
{{< figure src="wzr-900dhp01.jpg" alt="switch" width=800px >}}
「telnetd」を起動します。  
{{< figure src="wzr-900dhp02.jpg" alt="switch" width=800px >}}
WZR-900DHPにUSBメモリーを刺してtelnetで接続してBackupを取得します。
```tpl
telnet 192.168.11.1
cd /mnt/usb0_0
cat /proc/mtd > ./proc_mtd.txt
dd if=/dev/mtdblock/0 of=./mtdblock0.dd bs=1
dd if=/dev/mtdblock/1 of=./mtdblock1.dd bs=1
dd if=/dev/mtdblock/2 of=./mtdblock2.dd bs=1
dd if=/dev/mtdblock/3 of=./mtdblock3.dd bs=1
dd if=/dev/mtdblock/4 of=./mtdblock4.dd bs=1
dd if=/dev/mtdblock/5 of=./mtdblock5.dd bs=1
dd if=/dev/mtdblock/6 of=./mtdblock6.dd bs=1
dd if=/dev/mtdblock/7 of=./mtdblock7.dd bs=1
dd if=/dev/mtdblock/8 of=./mtdblock8.dd bs=1
cat mtdblock2.dd mtdblock3.dd > wzr900dhp_cfe.trx
nvram set boot_wait=on
nvram set wait_time=30
nvram commit
```
#### OpenWrtのインストール  
OpenWrtをDownloadします。
```tpl
curl -OL https://downloads.openwrt.org/releases/21.02.5/targets/bcm53xx/generic/openwrt-21.02.5-bcm53xx-generic-buffalo_wzr-900dhp-squashfs.trx
```
作業端末のIPを192.168.1.2/24にします。  
コンソールを開いて192.168.1.1にpingを送信します。
{{< figure src="wzr-900dhp03.jpg" alt="switch" width=800px >}}

pingにttl=100の応答が来たらOpenWrtをInstallします。  
ttl=100の応答は先ほど設定した「nvram set wait_time=30」の秒数で終わるので、応答中に下記を実施します。  
```tpl
curl -F "name=@/mnt/d/develop/workspace/wzr900dhp/openwrt-21.02.5-bcm53xx-generic-buffalo_wzr-900dhp-squashfs.trx" http://192.168.1.1/f2.htm
curl http://192.168.1.1/do.htm?cmd=nvram+erase
```
「Upload completed」が返ってくればInstall成功です。  
pingにttl=64の応答が来るまで待って、OpenWrtのWEB設定画面を開きます。  
http://192.168.1.1/
