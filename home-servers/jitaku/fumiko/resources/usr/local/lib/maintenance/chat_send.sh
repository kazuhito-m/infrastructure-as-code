#!/bin/bash

# Slack/Discordへ投稿するスクリプト。
#
# Usage
#   slackSend.sh data webhookUrl

data=${1}
webhookUrl=${2}

curl -X POST \
  -H 'Content-type: application/json' \
  --data "${data}" \
  ${webhookUrl}

