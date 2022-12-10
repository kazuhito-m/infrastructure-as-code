CREATE USER sonarqube WITH SUPERUSER PASSWORD 'sonarqube';
ALTER USER sonarqube SET search_path to sonarqube;
CREATE DATABASE sonarqube ENCODING 'UTF8' LC_COLLATE 'C' TEMPLATE 'template0' OWNER 'sonarqube';
ALTER DATABASE sonarqube SET timezone TO 'Asia/Tokyo';

\connect sonarqube;
CREATE SCHEMA IF NOT EXISTS sonarqube AUTHORIZATION sonarqube;
    