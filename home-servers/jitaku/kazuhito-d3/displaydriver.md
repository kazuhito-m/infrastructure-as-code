# ディスプレイドライバーインストール

## GTX1050 のドライバーをダウンロード

[このリンク](http://www.nvidia.com/content/DriverDownload-March2009/confirmation.php?url=/XFree86/Linux-x86_64/375.10/NVIDIA-Linux-x86_64-375.10.run&lang=us&type=GeForce) から、ドライバーをダウンロード。

※最初に何もしない状況から入れると、コンソールに降りた際に日本語ディレクトリが化けるので、Homeなどに移動しておく。

権限変更しておく。

```bash
chmod 755 NVIDIA*
```

## インストール

Xサーバをぶっ殺さないとインストールできないので殺す。

```bash
sudo service lightdm stop
```

こうすると急に黒画面になる(かつこのメモを見れなくなるw)ので、`Ctrl+Shift+F4` を押してコンソールログインする、ということを覚えておく。

あとは、先ほどのドライバーを実行する。

```bash
sudo ./NVIDIA*.run
```

## 再起動&確認

再起動したのち、希望の通りの解像度なり複数ディスプレイなどが表示されるかどうかを確認する。



