# MEMO

## 拠点間接続

自宅と実家を透過的に「地続きのネットワーク」としてつなぎたい。

以前から、いろいろな構想で考えてきたが、手段のコストが高かったので二の足踏んでいた。

が、技術の進化により「比較的安価で実現できる」ということが解ったので、やってみる。

### 構想

- 実家と自宅を「地続きのネットワーク」としてつなぐ
- `192.168.1.0/24` と `192.168.0.0/24` というふうに「セグメント違いのネットワーク」だが「IP打ったら相互に参照出来る」ようにしたい
- OpenSSHを使ったトンネリング簡易VPNとして実装したい(OpenVPNかな？)

### 参考記事

- https://shimonoakio.hatenadiary.org/entry/20091016/p1
- https://www.unixuser.org/~euske/doc/openssh/openssh-vpn.html