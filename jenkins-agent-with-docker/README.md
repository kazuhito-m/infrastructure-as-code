Jenkins Agent Container with Docker&DockerCompose
===

## What's this?

docker/docker-composeが叩けるJenkinsAgentコンテナ。

docker公式のcomposeイメージをベースに、Jenkins公式のJenkinsAgentコンテナのDockerfileを合成したようなカタチとなっています。

## Usage

1. Jenkinsを起動し「Launch agent via Java Web Start」なノードを作成してください
0. 作成されたノードをクリックし、表示された画面の `java -jar slave.jar ...` のコマンドサンプルから `-jnlpUrl` と `-secret` の後ろの値を取得してください
0. このREADME直下のファイルを「動かしたいDockerホスト」にDLしてください
0. `docker-compose.yml` の `environment` の値を、上記で取得した値に変更してください
0. `./start.sh` を実行してください
0. Jenkins側のnodeが「接続済み」になれば完了です