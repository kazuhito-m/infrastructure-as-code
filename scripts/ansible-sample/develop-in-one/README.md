# (small) develop in one

## What's this ?

開発に必要なサーバを色々と入れた、小さい「All in one」なサーバです。

- ContOS 6.7(finale)向け

以下がデフォルトで起動します。

- Jenkins
- Sonarqube
- Nexus repository server

## 完成後の接続情報

### URL

- Jenkins : http:/[hostname]:8080/
- Nexus : http:/[hostname]:8081/
- Sonarqube : http:[hostname]/(http80番)
  + sonarqubeだけはBasic認証

### ユーザ

基本的に簡易な感じに統一(基準とかあるならあとで考える)

- 一般ユーザ
    - jenkins
- 管理ユーザ
    - admin

---

## 前提

以下は「プロビジョニングの実行元ホスト(プロビジョニング対象とは異なる)」に予め行っている前提の設定です。

(対象のホスト内からでも可)

- git,anshible

※ContOS6系の例

```bash
yum update
yum install epel-release
yum install git
yum install ansible --enablerepo=epel-testing
```

## プロビジョニング実行方法

上記前提を整えた状態で、このREADMEが在るディレクトリで、以下を実行してください。

```bash
ansible-playbook --private-key=XXX.pem -i hosts -u root main.yml
```
## プロビジョニング後の手動作業

### Jenkinsの設定

- インストール後「内部のファイルからパスワードを抜け」と言われる
  - 今回、自身サーバの /var/local/jenkins へとデータディレクトリをマッピングしたので、 /var/local/jenkins/secrets/initialAdminPassword から抜きましょう
- Pluginのインストール
  - Install Suggest plugins を選ぶ
- 管理者ユーザ入力
  - admin で
- 一般ログイン用ユーザを追加
  - jenkinsでログイン出来るように

## Nexusの設定

[こちら](./setup-as-code/NEXUS_OPERATION.md)

## sonarqubeの設定

[こちら](./setup-as-code/SONARQUBE_OPERATION.md)
