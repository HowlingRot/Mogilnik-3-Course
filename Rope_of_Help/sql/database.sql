--for PostgreSQL

CREATE TABLE users(
id bigint PRIMARY KEY NOT NULL,
login varchar(255) NOT NULL,
password varchar(255) NOT NULL,
email varchar(255) NULL,
role_id bigint NOT NULL
);

CREATE TABLE profiles(
user_id bigint REFERENCES users(id) NOT NULL,
name varchar(30) NOT NULL,
foto varchar(255) NOT NULL,
sex varchar(1) NOT NULL,
birth_day date NOT NULL,
dossier text NULL,
hobby varchar(30)[] NULL,
profession varchar(30) NOT NULL,
PRIMARY KEY(user_id)
);

CREATE TABLE advertisements(
id bigint PRIMARY KEY NOT NULL,
title varchar(255) NOT NULL,
atext text NOT NULL,
creator_id bigint REFERENCES users(id) NOT NULL,
tags varchar(30)[] NULL
);
