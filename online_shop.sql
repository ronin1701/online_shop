





----------------------------users
create table users(
id serial primary key,
firstName varchar(50) not null,
lastName varchar(50) not null unique,
email varchar(50) not null unique,
updated_at timestamp default null);

insert into users (firstName,lastName,email)
values
('Astan','Serikov','serikovastik@gmail.com'),
('Aziret','Ramankulov','azik@gmail.com'),
('Almanbet','Totoev','alma@gmail.com'),
('Iskander','Alymov','iska@gmail.com'),
('Asel', 'Alybaeva','aselka@gmail.com'),
('Asel2', 'A2lybaeva','a2selka@gmail.com')

select * from users;
drop table users;
truncate table users cascade;


-----------------------------------------------------------------------------wallet
create table wallet(
id serial primary key,
user_id int references users(id),
user_sum integer default 0);


insert into wallet(user_id,user_sum)values(1,500);
insert into wallet(user_id,user_sum)values(2,600);
insert into wallet(user_id,user_sum)values(3,700);
insert into wallet(user_id,user_sum)values(4,800);
insert into wallet(user_id,user_sum)values(5,900);
insert into wallet(user_id,user_sum)values(6,200);


select * from wallet;
drop table wallet;
truncate table wallet;

-------------------------------------------------------------------------------animals
create table  product(
id serial primary key,
name varchar(50) not null,
price integer default 0,
description varchar(50) default ''
);

insert into product(name,price,description)values('Iphone',10,'Best product');
insert into product(name,price,description)values('Xiomi',120,'Nice smartphone');
insert into product(name,price)values('Zoppo',130);
insert into product(name,price)values('Lg',140);
insert into product(name,price)values('Nopia',150);
insert into product(name,price)values('Acer',140);



select * from product;
drop table product cascade;
truncate table animals;

--------------------------------------------------------------------------------categories
create table categories(
id serial primary key,
product_id int references product(id),
product_category varchar(50) not null
);

insert into categories(product_id,product_category)values(1,'New Smartphones');
insert into categories(product_id,product_category)values(2,'Old smartphones');
insert into categories(product_id,product_category)values(3,'Very good smartphones');
insert into categories(product_id,product_category)values(4,'Wow smartphones');
insert into categories(product_id,product_category)values(5,'Fast smartphones');
insert into categories(product_id,product_category)values(6,'Notebooks');

select * from categories;
drop table categories;
truncate table categories;

-----------------------------------------------------------------------user_buy_animals
create table user_buy_product(
id serial primary key, 
user_id int references users(id) not null,
product_id int references product(id) not null,
bought_at timestamp);

insert into user_buy_product(user_id,product_id,bought_at)values(1,1,current_timestamp);

select * from user_buy_product;
drop table user_buy_animal;
truncate table user_buy_animals;
---------------------------------------------------------delete trigger

create or replace function product_delete_audit() returns trigger 
 as $$
 	BEGIN
 		delete from audit
		WHERE user_id = (select id from users where users.id = old.id) ;
 		return old;
 	END
 $$ language plpgsql;

 create  trigger product_delete_audit_trigger before delete on users
 for each row execute procedure product_delete_audit();


select * from audit;

delete from users where id  = 1;
----------------------------------------------------------------insert trigger
create or replace function new_audit() returns trigger as $$
 	begin
 		insert into audit (user_id, entry_date , email) 
		values ((select id from users where id = new.id) ,current_timestamp,(select email from users where email = new.email));
 		RETURN new;
 	end 
 $$ language plpgsql;

 create  trigger audit_tr after insert on users
 for each row execute procedure new_audit();


create table audit(
user_id int  not null, entry_date varchar(100) not null,
email varchar(100));


insert into users (firstName,lastName,email)
values('Test22234','test22234','test22234@gmail.com');

select * from audit;
truncate table audit;
drop table audit;
select * from users;

select * from users left join audit on users.id = audit.user_id;

----------------------------------------------------------------update trigger

create or replace function update_audit() returns trigger as $$
 	begin
 		update audit set email = (select email from users where email = new.email),
		entry_date = current_timestamp
		WHERE user_id = old.id;
		 
	
 		RETURN old;
 	end 
 $$ language plpgsql;

 create trigger user_update_trigger after update on users
 for each row execute procedure update_audit();
 
 select * from users;
 select * from audit;
 
 
 update  users
 set email = 'Emirlan' where users.email = 'test22234@gmail.com';
---------------------------------------------------------------------
---------------------------------------------------------------------view and join
CREATE VIEW product_view AS
  SELECT product.*, price AS price_count
  FROM product
  LEFT OUTER JOIN (
    SELECT b.user_id, COUNT(*) price_count
    FROM   user_buy_product b
    GROUP BY b.user_id
  ) a ON a.user_id = product.id;
  
select * from product_view;










































----------------------------users
create table users(
id serial primary key,
firstName varchar(50) not null,
lastName varchar(50) not null unique,
email varchar(50) not null unique,
updated_at timestamp default null);

insert into users (firstName,lastName,email)
values
('Astan','Serikov','serikovastik@gmail.com'),
('Aziret','Ramankulov','azik@gmail.com'),
('Almanbet','Totoev','alma@gmail.com'),
('Iskander','Alymov','iska@gmail.com'),
('Asel', 'Alybaeva','aselka@gmail.com'),
('Asel2', 'A2lybaeva','a2selka@gmail.com')

-----------------------------------------------------------------------------wallet
create table cart(
id serial primary key,
createdAt timestamp default null,
user_id int references users(id));



insert into cart(user_id,)values(1,500);
insert into cart(user_id,user_sum)values(2,600);
insert into cart(user_id,user_sum)values(3,700);
insert into cart(user_id,user_sum)values(4,800);
insert into cart(user_id,user_sum)values(5,900);
insert into cart(user_id,user_sum)values(6,200);

-------------------------------------------------------------------------------animals
create table cart_item(
id serial primary key,
description varchar(50),
createdAt timestamp default null,
cart_id int references cart(id),
product_id int references product(id)
);

insert into cart_item(description)values('cellular ');
insert into cart_item(description)values('cell ');
insert into cart_item(description)values('cellphone');
insert into cart_item(description)values('handphone');
insert into cart_item(description)values('hand ');

------------------------------------------------------------------------------
create table product (
	id serial primary key,
	title varchar(50),
	createdAt timestamp default null,
	user_id int references users(id));
insert into product(title)values('iphone ');
insert into product(title)values('xiomi ');
insert into product(title)values('nokia ');
insert into product(title)values('zoppo ');
insert into product(title)values('samsung ');
--------------------------------------------------------------------------------categories
create table category(
	id serial primary key,
	title varchar(50));

insert into category(title)values('Smartphones ');
insert into category(title)values('Notebooks ');
insert into category(title)values('NotePad ');
insert into category(title)values('Books ');
insert into category(title)values('TV ');
----------------------------------------------------------------------------------
create table categories(
category_id int references category(id),
product_id int references product(id)
);

insert into categories(animal_id,animal_category)values(1,'Dog');
insert into categories(animal_id,animal_category)values(2,'Cat');
insert into categories(animal_id,animal_category)values(3,'Cat');
insert into categories(animal_id,animal_category)values(4,'Cat');
insert into categories(animal_id,animal_category)values(5,'Cat');
insert into categories(animal_id,animal_category)values(6,'Cat');

-----------------------------------------------------------------------user_buy_animals
create table user_order(
id serial primary key,
user_id int references users(id),
total int not null,
createAt timestamp default null);


insert into user_buy_animal(user_id,animal_id,bought_at)values(1,1,current_timestamp);
select * from user_buy_animal;
drop table user_buy_animal;
truncate table user_buy_animals;
---------------------------------------------------------delete trigger
create table order_item(
id serial primary key,
price integer, 
createdAt timestamp default null,
product_id int references product(id),
order_id int references user_order(id));
------------------------------------------------------
create or replace function product_audit() returns trigger 
 as $$
 	BEGIN
 		delete from product_audit
		WHERE product = (select id from product where product.id = old.id) ;
 		return old;
 	END
 $$ language plpgsql;

 create or replace trigger delete_audit_trigger before delete on product
 for each row execute procedure product_audit();


select * from product;
delete from product where id  = 3;
----------------------------------------------------------------insert trigger
create or replace function new_audit() returns trigger as $$
 	begin
 		insert into audit (user_id, entry_date , email) 
		values ((select id from users where id = new.id) ,current_timestamp,(select email from users where email = new.email));
 		RETURN new;
 	end 
 $$ language plpgsql;

 create  trigger audit_tr after insert on users
 for each row execute procedure new_audit();


create table audit(
user_id int  not null, entry_date varchar(100) not null,
email varchar(100));


insert into users (firstName,lastName,email)
values('Test22234','test22234','test22234@gmail.com');

select * from audit;
truncate table audit;
drop table audit;
select * from users;

select * from users left join audit on users.id = audit.user_id;

----------------------------------------------------------------update trigger

create or replace function update_audit() returns trigger as $$
 	begin
 		update audit set email = (select email from users where email = new.email),
		entry_date = current_timestamp
		WHERE user_id = old.id;
		 
	
 		RETURN old;
 	end 
 $$ language plpgsql;

 create trigger user_update_trigger after update on users
 for each row execute procedure update_audit();
 
 select * from users;
 select * from audit;
 
 
 update  users
 set email = 'Astik' where users.email = 'test22234@gmail.com';
---------------------------------------------------------------------
[16.01, 20:35] Астан эльдияр: ---------------------------------------------------------------------view and join
CREATE VIEW animals_view AS
  SELECT animals.*, price AS price_count
  FROM animals
  LEFT OUTER JOIN (
    SELECT b.user_id, COUNT(*) price_count
    FROM   user_buy_animal b
    GROUP BY b.user_id
  ) a ON a.user_id = animals.id;
  
select * from animals_view;