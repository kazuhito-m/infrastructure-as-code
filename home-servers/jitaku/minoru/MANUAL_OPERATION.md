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
5. 外からsshが接続できるか確認、一度ログインする
6. sudoは最初からかかるようになってるが、「パスワードを必ず指定するように」の設定を足す
    - /etc/sudoers.d/10_pi-nopasswd ファイルを編集し、ファイルを空にする
7. ip固定
    - ansibleの仕事で「外から参照出来る」必要が有り、Routerからこのマシンのhttpsポートが見えていないといけないため
    - `/etc/dhcpcd.conf` を編集して、IP固定する
8. reboot
9.  変更したipアドレスでログインを確認

### Ansbileでのプロビジョニング

1. `settings.yml`, `hosts` の内容を確認
2. `./run.sh`
3.  rebootし、httpsの接続を確認

---

## トラブルシューティング

- 再起動後、何故かNginxが立ち上がらない
  - ただし、ssh出来るように成った後、 `sudo systemctl start nginx` を叩けば立ち上がる
  - トラブルシュートはまだしてないから、原因は不明
