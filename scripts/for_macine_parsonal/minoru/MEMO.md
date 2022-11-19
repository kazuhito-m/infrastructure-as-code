## 手動でやった作業の記録

- apt-get install nginx
- vi /etc/nginx/sites-available/miura_wiki.conf
- ln -s /etc/nginx/sites-available/miura_wiki.conf /etc/nginx/sites-enabled/miura_wiki.conf
- sudo apt install certbot python3-certbot-nginx
- sudo certbot --nginx -d miura-wiki.f5.si
  - Ansibleの時どうする？
    - /etc/letsencrypt/archive/miura-wiki.f5.si フォルダが無かったら、実行しようか
    - nginx側とどう折り合いをつけるかがわからないが


## 参考

- https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04-ja

