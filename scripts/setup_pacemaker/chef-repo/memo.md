# コマンドのメモ

+ Berkshelfを使ってのパッケージ収集・更新コマンド

` berks vendor cookbooks`

+ Chef-solo実行

`chef-solo -c ./solo.rb -j ./nodes/pm01.json`

+ レシピ一個単位でChef-solo実行

`chef-solo -c ./solo.rb -o レシピ名`

+ 新レシピ追加

`knife cookbook create 新レシピ -o ./site-cookbooks/`


