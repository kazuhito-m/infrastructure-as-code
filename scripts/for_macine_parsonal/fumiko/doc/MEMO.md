必要リンクとコピペベース等
===

## Trables

### 仮想機で1GB程度のドライブを作ったところ、GPTの場合にRaid作成後エラーに

仮想機で1GBのドライブを設定し、 `manual_operation.md` の記述どおり、GPT設定でパーティションを作成。

`fdisk -l` などを行った際に、

```
Error: The primary GPT table is corrupt, but the backup appears OK, so that will
be used.
```

という記述がでて、処理が止まってしまう。

`gdisk` の r,c,w などで「直すことは出来る」ものの、一度作ったRAIDアレイだと、その後のext4のファイルシステム作成やらでエラーが起きてしまう。

---

おそらく「TB級でないのにGPT使ってるから」だとアタリをつけ、作成時にGPT以外を指定することで回避。

```bash
sudo parted /dev/sdb
mktable
New disk label type ? msdos
```
## Links

### インストール

- https://www.server-world.info/query?os=Debian_10&p=vagrant&f=1
- https://kazuhira-r.hatenablog.com/entry/2018/12/02/235925


### Vagrantfile入門

- https://qiita.com/daichi87gi/items/d5da33c76295ee32a735
- https://kitsune.blog/linux-environment

### Vagrant復数Disk追加

- https://qiita.com/kjtanaka/items/8f3e92e029e46f826754
- https://qiita.com/maueki/items/c4ce7c2b7834e3f4ad7d
  - Portは「基本2つしかない」「Deviceでコントロールする」みたい(おそらくIDEのmaster/slaveのやつ)
  - 今回は、結局「sdcをport:0,device:1」にした(恐らく1つ目のHDDと同じとこに居る…と思う)