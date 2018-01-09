#!/bin/bash

# Jenkins2に「前提となる設定」を流し込むスクリプト。
# jobや履歴情報は、別データで放り込むイメージ。

JENKINS_URL='http://localhost:8080'
USERNAME='admin'
PASSWORD='xxx'

PLUGINS='slack jacoco disk-usage nunit aws-lambda s3'

# Jenkins自体からjenkins-cli.jarを吐き出させる(PowerShellのそうとう古いやつでもいけるwget構文)
curl "$JENKINS_URL/jnlpJars/jenkins-cli.jar" > ./jenkins-cli.jar

# Pluginインストール

# プラグイン群
# https://updates.jenkins-ci.org/latest/ から、対応する名前を探し、".hpi"を取り除いたのがプラグイン名。
java -jar jenkins-cli.jar -s $JENKINS_URL install-plugin $PLUGINS --username $USERNAME --password $PASSWORD

# 特殊プラグイン。直にhpiファイルをインストール。
java -jar jenkins-cli.jar -s $JENKINS_URL install-plugin ./sonarqube-slack-pusher-1.7.1.hpi --username $USERNAME --password $PASSWORD


# 本体の設定 & ジョブの設定をZIPから展開し、インストールディレクトリにかぶせる & 再起動
java -jar jenkins-cli.jar -s $JENKINS_URL safe-restart --username $USERNAME --password $PASSWORD
