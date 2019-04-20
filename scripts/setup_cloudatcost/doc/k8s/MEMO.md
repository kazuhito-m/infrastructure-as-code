# k8s を始めるののメモ

## インストール

- https://raaaimund.github.io/tech/2018/10/23/create-single-node-k8s-cluster/
  - メインオペはこれを真似る
  - flannel を使う
- https://hakengineer.xyz/2018/07/14/post-1447/
- https://qiita.com/rk05231977/items/2c67ad47aecfd48c53ca
  - こちらは Callico をつかうようなので参考程度
- https://hakengineer.xyz/2018/05/28/post-1270/
  - dashboard のインストール はこちらを　真似る
- https://qiita.com/sheepland/items/0ee17b80fcfb10227a41
  - 上記の Dashbord の情報は古いみたいなので、URL などはこちらから
- https://kubernetes.io/docs/setup/independent/install-kubeadm/

## weave met 関係

- https://www.kaitoy.xyz/2018/05/04/kubernetes-with-weave-net/
  - 日本語インストール記事

## あかん状況になって「デストローイ！」ってしたくなったら…

- `sudo kubeadm reset` というコマンドがある
  - https://hakengineer.xyz/2018/05/24/post-1242/

## 構成の理解

- https://qiita.com/tkusumi/items/c2a92cd52bfdb9edd613
