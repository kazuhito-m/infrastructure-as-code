# Sonarqube Server での手作業

## 初期作業

- admin でログイン
- adminのパスワードを変更
- 日本語化
    - http://yohshiy.blog.fc2.com/blog-entry-305.html
- 最初のバックアップ
    - 内部から実行 `pg_dump -h localhost -U sonarqube sonarqube > first.pgdump ; gzip first.pgdump`
- ユーザ作成
  - jenkins
- プラグインをインストール
  - FindBugs
  - C#
  - Swift
    - アプリから入れられる公式のは「有償のもの」なので使えない
    - フリーから入れる
      - cd /opt/sonar/extensions/plugins/ && wget https://github.com/Backelite/sonar-swift/releases/download/0.3.2/backelite-sonar-swift-plugin-0.3.2.jar
      - service sonar restart

## プラグインインストール作業を一時的にやめてるもの

- `C/C++/Objective-C` のプラグインを入れると `license for cpp` とか言われてスキャンできない
- [sonar-cxx-plugin](https://github.com/SonarOpenCommunity/sonar-cxx/releases) を入れると「Sonarqubeの起動」自体できない(5.6でしかテストしてないからだと思われる)

ので、以下のオペレーションを殺している。（いつかやる）

- プラグインをインストール
  - C++用のやつ(非"C/C++/Objective-C"のもの)
      - `cd /opt/sonar/extensions/plugins`
      - `wget https://github.com/SonarOpenCommunity/sonar-cxx/releases/download/cxx-0.9.6/sonar-cxx-plugin-0.9.6.jar`
      - `service sonar restart`

## 参考文献

- [日本語化](http://qiita.com/yo1000/items/0af36c8bc5e944c1e42a)
- [Analyzing with SonarQube Scanner for Gradle](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Gradle)

### その他

- [postgrsqlのリストア・バックアップ](http://qiita.com/rice_american/items/ceae28dad13c3977e3a8)
