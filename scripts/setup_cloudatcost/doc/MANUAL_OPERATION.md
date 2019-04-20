# 手動作業

コードに出来ない手動作業を記載していく。

## 参考

- https://qiita.com/nightyknite/items/e05390cfcea7f4a1b2a9

## 初期設定

Ansibleを流す前に、以下作業を行った。

### ディストリビューションのアップグレード(メジャーバージョンごと)

- 「7日間未使用でシャットダウン」設定をOFFにする
  - Cloudatcostの管理パネルのModify>Change Server Run Modeで Normal Mode(Leave Power On)にする。
- ログインする
  - userは `root` 、パスワードはパネルの `i` のトコに表示されている
- Ubuntuのアップグレード
  - 以下は `byobu` 上でやる(最初から入っている模様)
    - その前に `byobu-config` でlogoを抑制
  - `sudo apt-get update -y && sudo apt-get dist-upgrade -y`
    - この時点で「boot領域が溢れている可能性がある」ので、クリアしておく
      - `dpkg -l linux-{image,headers}-"[0-9]*" | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e '[0-9]' | xargs sudo apt-get -y purge && apt-get autoremove -y`
  - `do-release-upgrade`
    - なんか、コマンドで `sudo iptables -I INPUT -p tcp --dport 1022 -j ACCEPT` しろって言うてくるのでそうする
    - CloudAtCostのサーバは古いので、とりあえず(壊れても良い)序盤にあげてしまう
  - `dpkg -l linux-{image,headers}-"[0-9]*" | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e '[0-9]' | xargs sudo apt-get -y purge && apt-get autoremove -y`
  - 最後再起動されるので、ログインし直し
  - `dpkg --get-selections` で２つ以上 `install` ならば、アンインストール/autoremoveする


### ユーザー＆接続系

- 一般ユーザ作成
  - `adduser [username]`
  - Ubuntuでは、このコマンドが「ディレクトリ付きで」作ってくれる
- `vi .bashrc` # HISTSZEに00加える
- sudo 設定
  - `gpasswd -a [username] sudo`
  - ここで一旦リブート後、sshかつ一般ユーザで入ってみる
- sshdの「鍵認証有効化」
  - `sudo vi /etc/ssh/sshd_config`
  - `#AuthorizedKeysFile %h/.ssh/authorized_keys` のコメントを外す
  - `sudo /etc/init.d/ssh restart`
- 一般ユーザ鍵作成
  - `ssh-keygen -t rsa`
  - `cd ~/.ssh ; mv id_rsa.pub authorized_keys ; chmod 600 authorized_keys`
- クライアント側からssh接続確認
  - `chmod 600 ~/.ssh/id_rsa` を忘れずに
- sshの設定「鍵認証のみ化」
  - `sudo vi /etc/ssh/sshd_config`
  - root封じ : `PermitRootLogin` を `no` に
  - passwordログイン封じ : `#PasswordAuthentication yes` のコメント外して `no` に
  - 再起動: `sudo shutdown -r now` (何故かsshd再起動ではだめ)

### ディスク関連

いつからか、仕様が変わって「LVM前提」「swapがパーティション(LV)でされる」ようになっている。それを是正する。

- swapパーテイションの削除
  - `sudo swapoff /dev/dm-1`
  - `sudo lvdisplay`
  - `sudo lvremove /dev/localhost-vg/swap_1`
  - `sudo lvextend -l +100%FREE /dev/localhost-vg/root`


## setup.sh(ansible)を走らせる前にやること

- `host_template` を `hosts` にコピーし、設定変更
- `CAC_KEY_FILE01` という変数に、「秘密鍵ファイルの場所」を設定

# 参考資料

- http://www.noah.org/wiki/Partition_editing


# その他

## いつのまにか「できなくなった」プロセス

デフォルトのパーティションが変わったのか「以下をやろうと思うと死ぬ」ようになっている。

- `/boot` の拡張
  - 絶対に「アップグレード時に/bootディレクトリの容量不足に陥る」ため、swap領域を削除し `/boot` に充当する
  - `swapoff -a` でswap機能を殺す
  - `vi /etc/fstab` で「Swapパーティションのマウント部分」を削除
  - `parted` を起動し、以下のコマンドを打つ
    - `print list` で確認
    - `rm 1`
    - `rm 2`
    - `mkpart primary ext4 1049kB 1150MB`
    - `set 1 boot on`
  - `resize2fs /dev/sda1` で/bootの認識サイズを更新する
  - `reboot`
  - `df -h` で「/bootが1ギガ程度ある」ことを確認

## TODO

- 「日に一回、イメージを削除する」のを流す
  - ここ参照 : https://stackoverflow.com/questions/37276849/why-is-the-default-ubuntu-boot-partition-so-small-how-can-i-increase-it
