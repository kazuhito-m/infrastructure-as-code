#!/usr/bin/groovy

/** 
 * gitのブランチ選択
 * URLが変数のgitブランチの選択
 * JenkinsのDynamicChoicePluginでの使用を想定。
 * パラメータ : GIT_URL
 */

def command = "git ls-remote -h $GIT_URL"

def proc = command.execute()
proc.waitFor()         

if ( proc.exitValue() != 0 ) {
  def list = [command,"Error, ${proc.err.text}"]
  return list
} 

def branches = proc.in.text.readLines().collect {
  it.replaceAll(/[a-z0-9]*\trefs\/heads\//, '') 
}   
return branches
