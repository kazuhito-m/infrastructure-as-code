# 手動オペレーション

## 前提

- ansible は流した後で操作

## 方針

- 指定はすべて「IP アドレス」で行う

## 操作

### master ノードセットアップ

manage 側で操作。

```
sudo kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl taint nodes --all node-role.kubernetes.io/master-

export kubever=$(kubectl version | base64 | tr -d '\n')
sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
```

### master ノードに dashbord をインストールする

https://hakengineer.xyz/2018/05/28/post-1270/

これに従い、作業を行う。

色々試した結果「HTTPSでしか、外へ公開できないし、APIが動いてくれない」ようなので、事故証明書を作るところからやる。

```bash
cd
mkdir certs
cd certs

openssl genrsa 2048 > dashboard.key
openssl req -new -key dashboard.key > dashboard.csr
# いろいろ聞かれますが全部enterで問題なし。

echo subjectAltName=DNS:testdashboard.work > san.ext
openssl x509 -days 3650 -req -signkey dashboard.key < dashboard.csr > dashboard.crt -extfile san.ext

kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kube-system
```

ダッシュボードの仕込みをする。

```bash
mkdir $HOME/dashboard
cd $HOME/dashboard

wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

vim kubernetes-dashboard.yaml

kubectl apply -f $HOME/dashboard/kubernetes-dashboard.yaml
```

途中、編集するのは以下の通り。

以下の部分はコメントアウト。

```
# ------------------- Dashboard Secret ------------------- #

#apiVersion: v1
#kind: Secret
#metadata:
# labels:
# k8s-app: kubernetes-dashboard
# name: kubernetes-dashboard-certs
# namespace: kube-system
#type: Opaque
#
```

以下部分を編集。

```
# ------------------- Dashboard Service ------------------- #

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 32075 # ここと
  type : NodePort # ここに追加
  selector:
    k8s-app: kubernetes-dashboard
```

以下は末尾に追加。

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
```

### 接続確認

https://[サーバIP]:32075 で「ログイン画面」がでればOK。

トークンの取得は、コンソールから以下を実行。

```bash
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```


## ネットワークが繋がらない問題

Unable to update cni config: No networks found in /etc/cni/net.d

というのが起きる。

- https://yunkt.hatenablog.com/entry/2018/08/13/200123 読んでやってみる
- https://raaaimund.github.io/tech/2018/10/23/create-single-node-k8s-cluster/ をヤッてみる
- Caico にしてみる

---

最終的な結論として…「DockerCEで入れたDockerのバージョンがおかしい」という原因だった。

https://github.com/kubernetes/kubeadm/issues/228

なので、「Ubuntuのdocker.ioを使う」と上手く行くことは検証。（Flannel,weaveで確認）
