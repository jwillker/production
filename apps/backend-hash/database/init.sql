####################################################################################################################################
#
# Users
#
####################################################################################################################################

create table users (
	id varchar(255) primary key,
	first_name varchar(255) not null,
	last_name varchar(255) not null,
	date_of_birth date not null
) collate=utf8_unicode_ci;

create index users_first_name_index on users (first_name);
create index users_last_name_index on users (last_name);
create index users_date_of_birth_index on users (date_of_birth);	

INSERT INTO users (id, first_name, last_name, date_of_birth) VALUES ("8PiisPOauwPZzWTT", "Pedro", "Viegas", "1988-06-01");
INSERT INTO users (id, first_name, last_name, date_of_birth) VALUES ("tARa/xEqGsljjYtl", "João", "Souza", "1988-03-10");
INSERT INTO users (id, first_name, last_name, date_of_birth) VALUES ("I2BoXtZMW20A6Zxc", "Lucas", "Koch", "1988-12-07");
INSERT INTO users (id, first_name, last_name, date_of_birth) VALUES ("MXPmNsurzjAlVxwO", "Bruno", "Porto", "1988-01-15");

####################################################################################################################################
#
# Products
#
####################################################################################################################################

create table products (
	id varchar(255) primary key,
	title varchar(255) not null,
	description varchar(255) not null,
	price_in_cents int not null
);

create index products_title_index on products (title);

INSERT INTO products (id, title, description, price_in_cents) VALUES ("GyhyFM3T3U88mg4d", "Bottle", "Good", 890);
INSERT INTO products (id, title, description, price_in_cents) VALUES ("QoPvAyf9A5kntaUH", "Chair", "Bad", 567);
INSERT INTO products (id, title, description, price_in_cents) VALUES ("Gwck3TO3oxI6+msE", "Lamp", "Ugly", 456);
INSERT INTO products (id, title, description, price_in_cents) VALUES ("AeLRZ1pSSi54Eo21", "Candy", "Sweet", 123);
