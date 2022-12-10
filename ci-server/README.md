# インターネット(AWS)上の Jenkins

## What's this ?

- ここは、外部ネットワークからビルド・リリース状況の把握ができる Jenkins 用サーバの「Infrastracuture As Code」しているファイル群です
- Windows ではなく Linux です
  - ContOS 6.9(finale)向け
- 主に「Lan内部(AWS中含む)でデプロイしたい場合」のために使用する予定です

## 完成後の接続情報

### URL

- Jenkins : http:/[aws-hostname]:8080/
- Nexus : http:/[aws-hostname]:8081/
- Sonarqube : http:[aws-hostname]/(http80 番)
  - sonarqube だけは Basic 認証

### ユーザ

基本的に簡易な感じに統一(基準とかあるならあとで考える)

- 一般ユーザ
  - jenkins/(いつもの)
- 管理ユーザ
  - admin/(いつもの)

---

## 前提

以下は「プロビジョニングの実行元ホスト(プロビジョニング対象とは異なる)」に予め行っている前提の設定です。

(対象のホスト内からでも可)

- git,anshible

※ContOS6 系の例

```bash
yum update
yum install epel-release
yum install git
yum install ansible --enablerepo=epel-testing
```

## プロビジョニング実行方法

上記前提を整えた状態で、この README が在るディレクトリで、以下を実行してください。

```bash
ansible-playbook --private-key=XXX.pem -i hosts -u ec2-user main.yml
```

## プロビジョニング後の手動作業

### Jenkins の設定

- インストール後「内部のファイルからパスワードを抜け」と言われる
  - 今回、自身サーバの /var/local/jenkins_home へとデータディレクトリをマッピングしたので、 /var/local/jenkins_home/secrets/initialAdminPassword から抜きましょう
- Plugin のインストール
  - Install Suggest plugins を選ぶ
- 管理者ユーザ入力
  - admin で
- 一般ログイン用ユーザを追加
  - jenkins でログイン出来るように

## Jenkins以外の個々サーバの設定

- [Nuxus Repository Server](./doc/NEXUS_OPERATION.md)
- [SonarQube](./doc/SONARQUBE_OPERATION.md.md)
