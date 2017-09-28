CREATE USER postgis_sample_user WITH SUPERUSER PASSWORD 'postgis_sample_user';
CREATE DATABASE postgis_sample ENCODING 'UTF8' LC_COLLATE 'C' TEMPLATE 'template0' OWNER 'postgis_sample_user';
\connect postgis_sample
CREATE EXTENSION postgis;
CREATE SCHEMA AUTHORIZATION postgis_sample_user;
