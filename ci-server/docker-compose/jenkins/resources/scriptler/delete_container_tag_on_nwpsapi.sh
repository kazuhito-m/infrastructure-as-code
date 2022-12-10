#!/bin/bash

GITLAB_PRIVATE_TOKEN='_53wwgDhVn-ZsZsdnLgc'
GITLAB_TAG_LIST_URL='https://https://gitlab.com/api/v4/projects/all_kazuhito%2Ftest/registry/repositories/1/tags'

curl --request DELETE \
  --data 'name_regex_delete=^[1-9].*[0-9]-.*$' \
  --data 'older_than=7d' \
  --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" \
  ${GITLAB_TAG_LIST_URL}
