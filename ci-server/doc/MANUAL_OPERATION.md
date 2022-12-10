# 手動作業

Jenkinsに対する、コードに出来ない手動作業を記載していく。

## 初期設定

- Gitのクレデンシャルを追加する
- Slackの仕込みをする
  - http://qiita.com/ryuthky_github/items/c7e68fba13ddf230159a
  - Slack側
  - Jenkinsfileに設定

## LAN内の仮想機をagent化

### JNLPで使うポートを決め有効化

グローバルセキュリティの設定 から `TCP port for JNLP agents` で `固定` を選び、ポートを入力する。

今回は `49600` を使う。

念の為 `Java Web Start Agent Protocol/3` をOnしておく。

### AWSのJenkinsに対するセキュリティグループに穴をあける

JenkinsサーバのEC2が採用しているセキュリティグループに、インバウンドで "カスタムTCPルール","49600ポート","送信元:
0.0.0.0/0" で、新ルールを追加。

(AsCodeできているので必要無いが、一度目はansibleのiptablesを変更、実行した。)

### ノードの新規作成

`Jenkinsの管理` -> `ノードの管理` -> `新規ノード作成` をクリックし、以下の情報を入力、保存する。

- ノード名 : agent-develop-windows
- 説明 : AWS内環境での、Microsoft系のプロダクトのテスト・ビルドを行うための開発端末ノード
- リモートFSルート : C:\jenkins_node
- 用途 : このマシーンの特定ジョブ専用にする
- 起動方法 : Launch agent via Java Web Start
- 可用性 : デフォルト

### AWS内のWindows端末で"agent.jar"を起動

具体的には、このソースリポジトリの

`src/scripts/jenkins-agent-jnlp.bat`

を、Windowsマシン(今回は 10.133.40.102)に配置し、スタートアップにショートカットを作った。

また、初回実行のため、そのスタートアップのショートカットを実行し、Jenkinsの画面で「オンラインになるか」を確認した。

### ジョブを作り、Pipelinescriptにより「Windowsのコマンド」を実行

「何が出来るか」の「ある程度」を、Pipelineジョブにて作成。

確認したのは

- システムコマンド(例はipconfig)が叩けるか
- Jenkinsの枠組みの外(C:\ 直下等)においてあるバッチなどを叩けるか

当たり。

### Microsoft系のプロジェクトでJenkinsfileを作成し、実際にpush実行してみる

### 参考

- http://haws.haw.co.jp/tech/jenkins-slave-nat-deploy/
- http://qiita.com/kiarina/items/2827776cc267cb9a6eb8/

---

## AWSのLAN内のLinuxをagent化

参考 : http://qiita.com/narumi_/items/146924d3b08490ef78af

### ノードの新規作成

`Jenkinsの管理` -> `ノードの管理` -> `新規ノード作成` をクリックし、以下の情報を入力、保存する。

- ノード名 : agent-develop-linux01
- 説明 : AWS環境での、プロダクトのテスト・ビルドを行うためのノード
- リモートFSルート : /var/lib/jenkins
- 用途 : このマシーンの特定ジョブ専用にする
- 起動方法 : Launch agent via Java Web Start
- 可用性 : デフォルト
