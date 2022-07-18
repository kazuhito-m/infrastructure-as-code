#!/bin/bash

# Slackへ投稿するスクリプト。
#
# JenkinsPipelineで使える `slackSend` メソッドリスペクト。
# Usage
#   slackSend.sh data webhookUrl

data=${1}
webhookUrl=${2}

curl -X POST \
  -H 'Content-type: application/json' \
  --data "${data}" \
  ${webhookUrl}

