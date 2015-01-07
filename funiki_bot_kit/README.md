funiki_bot_kit
==============

## What's this ?

TwitterのBotを立てるためのDockerfile & スクリプト群です。

これを使い、DockerImageをビルド、Dockerkコンテナを建てることにより「誰か実在のTwitterIDの方に似せたTwitterBot」を運用出来るように成ります。

## author

Kazuhito Miura ( [@kazuhito_m](https://twitter.com/kazuhito_m "kazuhito_m on Twitter") )

## 導入に必要な条件

+ 入れるサーバにDockerとgitクライアントがある
+ 入れるサーバがインターネットに繋がる
+ ターゲットとなるTwitterIDの方が、Twilogサイトに登録してる
+ Twitterに「Bot用アカウント」が存在する

## 導入手順

### githubから、本キット(Dockerファイル群)をダウンロードする

git clone https://github.com/kazuhito-m/dockers.git
cd ./dockers/funiki_bot_kit

### Dockerイメージをビルド & 起動する

./build_and_start.sh

※数分かかります

※コンソールにハッシュ値っぽいものが出て、"docker ps" を叩いた際に"funiki_bot_kit_1"と出ていたら正常です。

### SSHログイン & 設定ファイル整備

ssh -p 10022 hubot@localhost

hubot/hubot で。

ログインすると直下に　./funiki-hubot というプログラムが落ちているので、
"cd ./funiki-hubot" で移動、

2つのファイル、

0. initial_data.txt
0. twitter_id_settings.bsh

を、例を見ながら修正し、最期に「流し込みのスクリプト」を叩いてください。

./import_initial_data.sh

### bot起動

./run_hubot4twitter.bsh

制御がすぐに帰ってきますが、起動しています。
当該のTwitterIDにメンションで「なんか言って！」とか伝えてみて、なんか言い出したら完了です。

### 停止時

コンテナごと"docker kill"
