create role db_user login password 'password';
create database db_name;
grant all privileges on database db_name to db_user;
