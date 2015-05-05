# このレシピを作る上での治験をまとめたメモ

# コマンドのメモ

+ Berkshelfを使ってのパッケージ収集・更新コマンド

` berks vendor cookbooks`

+ Chef-solo実行

`chef-solo -c ./solo.rb -j ./nodes/pm01.json`

+ レシピ一個単位でChef-solo実行

`chef-solo -c ./solo.rb -o レシピ名`

+ 新レシピ追加

`knife cookbook create 新レシピ -o ./site-cookbooks/`


## 参照したURL郡

### Chefのリソース系

https://docs.chef.io/resource_bash.html
https://docs.chef.io/resource_link.html
http://devlab.isao.co.jp/chef-solo_base_setting-recipe/
http://yeahoo.hatenablog.jp/entry/2014/03/01/194011
http://qiita.com/ryurock/items/c99215e25bd2ff846207

### corosync/pacemaker設定系

http://news.mynavi.jp/news/2013/05/14/092/
http://www.ns-lab.org/wiki/?Linux%2FSource%2FCorosync
http://www.ns-lab.org/wiki/?Linux%2FSource%2FPacemaker

固有の基礎

http://gihyo.jp/admin/serial/01/pacemaker/0002
