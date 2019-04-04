# 手動オペレーション

## 前提

- ansible は流した後で操作

## 方針

- 指定はすべて「IP アドレス」で行う

## 操作

### master ノードセットアップ

manage 側で操作。

```
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=[サーバのIP]

mkdir $HOME/.k8s
sudo cp /etc/kubernetes/admin.conf $HOME/.k8s/
sudo chown $(id -u):$(id -g) $HOME/.k8s/admin.conf
export KUBECONFIG=$HOME/.k8s/admin.conf
echo "export KUBECONFIG=$HOME/.k8s/admin.conf" | tee -a ~/.bashrc

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
kubectl taint nodes --all node-role.kubernetes.io/master-
```

### master ノードに dashbord をインストールする

```
mkdir $HOME/dashboard
cd $HOME/dashboard

wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/alternative/kubernetes-dashboard.yaml

vim kubernetes-dashboard.yaml

kubectl apply -f /home/kazuhito/dashboard/kubernetes-dashboard.yaml
kubectl apply -f /home/kazuhito/dashboard/role_binding_dashboard.yaml


vi kubernetes-dashboard.yaml で編集
https://qiita.com/sugimount/items/689b7cd172c7eaf1235f#dashboard-service-account%E3%81%AB%E7%AE%A1%E7%90%86%E6%A8%A9%E9%99%90%E3%82%92%E4%B8%8E%E3%81%88%E3%82%8B

```

## ネットワークが繋がらない問題

Unable to update cni config: No networks found in /etc/cni/net.d

というのが起きる。

- https://yunkt.hatenablog.com/entry/2018/08/13/200123 読んでやってみる
- https://raaaimund.github.io/tech/2018/10/23/create-single-node-k8s-cluster/ をヤッてみる
- Caico にしてみる
