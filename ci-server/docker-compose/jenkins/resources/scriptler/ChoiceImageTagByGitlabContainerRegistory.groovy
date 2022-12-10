#!/usr/bin/groovy
import groovy.json.*
/** 
 * gitlabのContainerRegistory内の「特定のイメージ」のTagの一覧取得。
 *
 * gitlabのAPIを使用し、指定されたリポジトリのContainerRegistoryに登録されているTagの一覧を取得する。
 * gitlabサーバのURL、AccessTokenはプログラムの中に埋まってる(変更は出来ない)
 * JenkinsのDynamicChoicePluginでの使用を想定。
 * パラメータ : 
 * - GROUP_AND_REPOSITORY: gitlab内のグループとリポジトリの文字列。例:"group/REPOSITORY"
 * - REGISTRY_ID: gitlab内の『コンテナレジストリ」のID(プロジェクトごとにレジストリがあるのに、なぜか通し番号)
 */

final GITLAB_PARSONAL_APP_TOKEN = '[not set. please set gitlab token.]'
final PAR_PAGE = 100

final repoId = java.net.URLEncoder.encode(GROUP_AND_REPOSITORY, "UTF-8")
final registoryId = REGISTRY_ID
final tagsUrlHead = "https://https://gitlab.com/api/v4/projects/${repoId}/registry/repositories/${registoryId}/tags?per_page=${PAR_PAGE}"

def pageCount = 0
def allTags = []
def tags
while (true) {
    final url = "${tagsUrlHead}&page=${++pageCount}".toURL()
    final jsonText = url.getText(requestProperties: ['Private-Token': GITLAB_PARSONAL_APP_TOKEN])
    tags = new JsonSlurper()
        .parseText(jsonText)
        .collect { it.name }
    allTags.addAll(tags)
    if (tags.size() < PAR_PAGE) break
}
final list = allTags.reverse()

return list
