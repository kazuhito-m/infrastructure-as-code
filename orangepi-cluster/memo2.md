# orangepi の設定メモ2

## OrengePIの基本設計

- 使うのは `armbian`
  - 時間の流れで「OrengePIの標準ディストリが廃る」「逆にarmbianが安定してくる」というトレンドがあるため

### 参照記事

- https://www.armbian.com/orange-pi-pc/
  - 自分が持ってる機材の `armbian` のDLページ
- https://hrvtuirvw.net/blog/setting-up-orange-pi-pc/

---

## k8sの構想

---

## Ceph関連

### 参考記事

- http://kimoota.wiki.fc2.com/wiki/Ceph%2F%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E6%BA%96%E5%82%99#:~:text=ceph%E3%81%AF%E6%9C%80%E4%BD%8E1%E5%8F%B0,%E3%81%A8%E8%A1%A8%E3%81%99%E3%81%93%E3%81%A8%E3%81%AB%E3%81%97%E3%81%BE%E3%81%99%E3%80%82


---

## ネットワーク関連

構想的には「違うセグメント(IPv4帯)でクラスタを組む」「相互に参照できる」にしたい。

そのため「ルータを挟んで別ネットワークにする」ことを行う。

### 手順

### 参考記事

- https://twitter.com/kazuhito_m/status/1607778689173032961
- https://blog.futurestandard.jp/entry/2017/06/02/125745
- 理論の勉強、具体的な手段は異なる
  - https://www.juniper-ne.jp/blog/provider/routing-table.html
  - http://www.runsurunet.com/2017/10/13/%E5%88%A5%E3%81%AE%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9/
