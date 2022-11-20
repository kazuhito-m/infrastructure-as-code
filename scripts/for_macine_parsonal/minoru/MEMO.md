## 手動でやった作業の記録

## Nginxの設定

- apt-get install nginx
- vi /etc/nginx/sites-available/miura_wiki.conf
- ln -s /etc/nginx/sites-available/miura_wiki.conf /etc/nginx/sites-enabled/miura_wiki.conf
- sudo apt install certbot python3-certbot-nginx
- sudo certbot --nginx -d miura-wiki.f5.si
  - Ansibleの時どうする？
    - /etc/letsencrypt/archive/miura-wiki.f5.si フォルダが無かったら、実行しようか
    - nginx側とどう折り合いをつけるかがわからないが

### 参考

- https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04-ja

## Growi設定

- curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
- nvm install v16.18.1
- npm install -g npm@6.14.7
- npm install -g yarn
- sudo apt-get install openjdk-17-jdk
- sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
- sudo apt-get install apt-transport-https
- sudo echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
- sudo apt-get update && sudo apt-get install elasticsearch
- sudo systemctl start elasticsearch
- sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji
- sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
- sudo apt-get install gnupg
- wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
- echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
- sudo apt-get update
- sudo apt install mongodb-org
- sudo systemctl enable --now mongod
- wget https://github.com/weseek/growi/archive/refs/tags/v5.1.8.tar.gz
- gunzip ./v5.1.8.tar.gz
- sudo tar xvf ./v5.1.8.tar -C /opt
- sudo rm -rf /opt/growi
- sudo mv /opt/growi-5.1.8 /opt/growi
- cd /opt/growi && sudo npm install
- sudo MONGO_URI=mongodb://localhost:27017/growi  ELASTICSEARCH_URI=http://localhost:9200/growi npm start


### 参考

- https://qiita.com/steepay/items/96605cfbdd78995d707f
- https://linuxhint.com/install-elasticsearch-debian/
- https://arkgame.com/2021/12/24/post-303135/
- https://www.mongodb.com/docs/manual/reference/installation-ubuntu-community-troubleshooting/
- http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 Release
- https://docs.npmjs.com/cli/v8/commands/npm-version
- https://qiita.com/guai3/items/4d38dcb8a877951b718a
