# Nexus Repository Server での手作業

## 初期作業

- adminでログイン
- ユーザ設定周り
  - admin のパスワードを「いつもの」に
  - anonymous の Status を Disabled に
  - 新規ユーザを jenkins で作る
    - Roleは以下の2つをつける(deploymentのデフォルトユーザと一緒)
      - Nexus Deployment Role
      - Repo: All Repositories (Full Control)
  - develoyment ユーザは削除
- リポジトリを2つ追加
  1. JCenter
  2. Seaser2 Maven Repository

### 自社用リポジトリ作成作業

- `admin` ユーザでログイン
- ひだりメニューから `Repositories` クリック、ペイン表示
- タブのメニューから `Add` -> `Hosted Repository` クリック
- 以下の入力を行うって `Save` をクリック
  - Repository ID:commonlibrary
  - Repository Name:Common Library

これで「自社製のライブラリを登録するリポジトリ」が作成出来る

### 自社用リポジトリ公開設定

- ひだりメニューから `Repositories` クリック、ペイン表示
- 右上ペインから `Public Repositories` クリック
- 左下ペイン `Available Repositories` にある `Common Library` を選択、 `<|` をクリック
- 左下ペイン `Orderd Group Repositories` に `Common Library` が移動したことを確認

## 参考文献

- <https://terasolunaorg.github.io/guideline/public_review/Appendix/Nexus.html#upload-3rd-party-artifact-ex-ojdbc6-jar>
