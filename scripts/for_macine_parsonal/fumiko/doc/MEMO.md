必要リンクとコピペベース等
===

## Links

### インストール

- https://www.server-world.info/query?os=Debian_10&p=vagrant&f=1
- https://kazuhira-r.hatenablog.com/entry/2018/12/02/235925


### Vagrantfile入門

- https://qiita.com/daichi87gi/items/d5da33c76295ee32a735

### Vagrant復数Disk追加

- https://qiita.com/kjtanaka/items/8f3e92e029e46f826754
- https://qiita.com/maueki/items/c4ce7c2b7834e3f4ad7d
  - Portは「基本2つしかない」「Deviceでコントロールする」みたい(おそらくIDEのmaster/slaveのやつ)
  - 今回は、結局「sdcをport:0,device:1」にした(恐らく1つ目のHDDと同じとこに居る…と思う)