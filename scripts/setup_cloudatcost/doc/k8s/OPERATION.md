# 手動オペレーション

## 前提

- ansible は流した後で操作

## 方針

- 指定はすべて「IP アドレス」で行う

## 操作

### master ノードセットアップ

manage 側で操作。

- docker info | grep -i cgroup
- sudo kubeadm init --pod-network-cidr=10.244.0.0/16
- 一般ユーザのために、最後に表示されたものをコピペ

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

- cat /proc/sys/net/bridge/bridge-nf-call-iptables
  - 結果が 1 であることを確認
- kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml

### master ノードに dashbord をインストールする

```bash
cd
mkdir certs
cd certs
openssl genrsa 2048 > dashboard.key
openssl req -new -key dashboard.key > dashboard.csr
# いろいろ聞かれますが全部enterで問題なし。
echo subjectAltName=DNS:[表示用DNS名] > san.ext
openssl x509 -days 3650 -req -signkey dashboard.key < dashboard.csr > dashboard.crt -extfile san.ext
```

secret の作成

```
kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kube-system

kubectl get secret --all-namespaces
# kubernetes-dashboard-certs があることを確認。
```

```bash
mkdir $HOME/dashboard
cd $HOME/dashboard

wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/alternative/kubernetes-dashboard.yaml
vim kubernetes-dashboard.yaml

  388  kubectl apply -f /home/kazuhito/dashboard/kubernetes-dashboard.yaml
  425  kubectl apply -f /home/kazuhito/dashboard/role_binding_dashboard.yaml

```

- vi kubernetes-dashboard.yaml で編集
  - https://qiita.com/sugimount/items/689b7cd172c7eaf1235f#dashboard-service-account%E3%81%AB%E7%AE%A1%E7%90%86%E6%A8%A9%E9%99%90%E3%82%92%E4%B8%8E%E3%81%88%E3%82%8B


## ネットワークが繋がらない問題

Unable to update cni config: No networks found in /etc/cni/net.d

というのが起きる。

- https://yunkt.hatenablog.com/entry/2018/08/13/200123 読んでやってみる
- Caicoにしてみる
