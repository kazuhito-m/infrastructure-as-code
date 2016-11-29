# 手動作業

コードに出来ない手動作業を記載していく。

## 初期設定

Ansibleを流す前に、以下作業を行った。

- 一般ユーザ作成
- sudo 設定
  - `gpasswd -a [username] sudo`
- sshdの「鍵認証有効化」
  - `sudo vi /etc/ssh/sshd_config`
  - `#AuthorizedKeysFile %h/.ssh/authorized_keys` のコメントを外す
  - `sudo /etc/init.d/ssh restart`
- 一般ユーザ鍵作成
  - `ssh-keygen -t rsa`
  - `cd ~/.ssh ; mv id_rsa.pub authorized_keys ; chmod 600 authorized_keys`
- クライアント側からssh接続確認
  - `chmod 600 ~/.ssh/id_rsa` を忘れずに
- sshの設定
- sshdの「鍵認証有効化」
  - `sudo vi /etc/ssh/sshd_config`
  - root封じ : `PermitRootLogin` を `no` に
  - passwordログイン封じ : `#PasswordAuthentication yes` のコメント外して `no` に
  - 再起動: `sudo shutdown -r now` (何故かsshd再起動ではだめ)