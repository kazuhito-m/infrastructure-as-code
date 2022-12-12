セットアップ手動作業
===

全てをAsCode出来ないので、手動の手順を記す。

2022/07/20 `apt-get dist-upgrade` したら再起動不能になったので、再度インストール。

(以前のこのマシンが「何の責務だったのか」は残ってない。)

## Raspabinインストール＆付属設定

### Raspberry PI OSのインストール

1. [Raspberry PI Imager](https://www.raspberrypi.com/software/)を使って、対象microSDへイメージ書き込み
2. SDカードを指して、RaspberryPI起動
3. 最新のRaspaberryOSでは「ユーザを最初に指定する」のでkazuhitoを追加
4. 再起動
5. sudoは最初からかかるようになってるが、「パスワードを必ず指定するように」の設定を足す
    - /etc/sudoers.d/10_pi-nopasswd ファイルを編h宗旨
6. systemctl enable ssh && reboot
7. 外からsshが接続できるか確認、一度ログインする
8. `ip a` を叩き、IPアドレスを把握しておく

### Ansbileでのプロビジョニング

1. `settings.yml` の内容を確認
2. `hosts` を「DHCPで振られたIP」に一時的に変更
3. `./run.sh`
4.  rebootし、httpsの接続を確認
