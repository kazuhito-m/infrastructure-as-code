# 手動作業

コードに出来ない手動作業を記載していく。

## 参考

- https://qiita.com/nightyknite/items/e05390cfcea7f4a1b2a9

## 初期設定

Ansibleを流す前に、以下作業を行った。

- 「7日間未使用でシャットダウン」設定をOFFにする
  - Cloudatcostの管理パネルのModify>Change Server Run Modeで Normal Mode(Leave Power On)にする。
- ログインする
  - userは `root` 、パスワードはパネルの `i` のトコに表示されている
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
- 一般ユーザ作成
  - `adduser user_name`
  - Ubuntuでは、このコマンドが「ディレクトリ付きで」作ってくれる
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
- Ubuntuのアップグレード
  - 以下は `byobu` 上でやる(最初から入っている模様)
    - その前に `byobu-config` でlogoを抑制
  - `sudo apt-get update -y && sudo apt-get dist-upgrade -y`
  - `sudo do-release-upgrade`
    - なんか、コマンドで `sudo iptables -I INPUT -p tcp --dport 1022 -j ACCEPT` しろって言うてくるのでそうする
  - CloudAtCostのサーバは古いので、とりあえず(壊れても良い)序盤にあげてしまう
  - 最後再起動されるので、ログインし直し
  - `dpkg --get-selections` で２つ以上 `install` ならば、アンインストール/autoremoveする

## setup.sh(ansible)を走らせる前にやること

- `host_template` を `hosts` にコピーし、設定変更
- `CAC_KEY_FILE01` という変数に、「秘密鍵ファイルの場所」を設定

# 参考資料

- http://www.noah.org/wiki/Partition_editing
