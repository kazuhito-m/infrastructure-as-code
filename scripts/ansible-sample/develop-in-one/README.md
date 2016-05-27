# (small) develop in one

## What's this ?

開発に必要なサーバを色々と入れた、小さい「All in one」なサーバです。

以下がデフォルトで起動します。

- Jenkins
- Sonarqube
- Nexus repository server

## 前提

- 以下は手動でインストールしている前提です

git,anshible

```bash
yum update
yum install epel-release
yum install git
yum install ansible --enablerepo=epel-testing
```

## プロビジョニング実行方法

上記前提を整えた状態で、このREADMEが在るディレクトリで、以下を実行してください。

```bash
ansible-playbook -i hosts main.yml --ask-pass
```
## プロビジョニング後の手動作業

### Jenkinsの設定

http://[当該host]:8080/ をブラウザで確認し、Jenkinsの設定をします。

- インストール後「内部のファイルからパスワードを抜け」と言われる
  - 今回、自身サーバの /var/local/jenkins へとデータディレクトリをマッピングしたので、 /var/local/jenkins/secrets/initialAdminPassword から抜きましょう
- Pluginのインストール
  - Suggest plugin install を選ぶ
- 管理者ユーザ入力
- 一般ログイン用ユーザを追加
