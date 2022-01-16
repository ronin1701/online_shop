create table users(
id serial primary key,
firstName varchar(50) not null,
lastName varchar(50) not null unique,
email varchar(50) not null unique,
updated_at timestamp default null);

insert into users (firstName,lastName,email)
values
('Dan','Yankov','denyan@gmail.com'),
('Lebron','James','Lejas@gmail.com'),
('Alman','Boyka','albo@gmail.com'),
('Filka','John','Fijo@gmail.com'),
('Dana', 'Black','danb@gmail.com'),
('Seousy', 'Timber','Stimb@gmail.com')

select * from users;

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


create table user_buy_product(
id serial primary key, 
user_id int references users(id) not null,
product_id int references product(id) not null,
bought_at timestamp);

insert into user_buy_product(user_id,product_id,bought_at)values(1,1,current_timestamp);

select * from user_buy_product;

create table user_log(
user_id int  not null, entry_date varchar(100) not null,
email varchar(100));

create table delete_history (
	user_id int  not null, 
	entry_date varchar(100) not null,
	email varchar(100));

--delete trigger

create or replace function deletes()
returns trigger as
$$
begin
	IF 1 > 0 THEN
INSERT INTO delete_history (
  id,
  user_id,
  entry_date,
  email
)
VALUES
(id,
 user_name,
 timestamp,
 email);
      select * from users where id = exists (select id from users where id = 1);		
	end if;
	return null;
end;
$$Language plpgsql;

CREATE TRIGGER rowdelete
AFTER DELETE
ON users
FOR EACH ROW
EXECUTE PROCEDURE deletes();


alter table users add column changed_id BIGINT;

DELETE FROM users WHERE id = 1;

select * from users;


select * from delete_history;

delete from users where id  = 1;
--insert trigger
create or replace function insert_user() returns trigger as $$
 	begin
 		insert into user_log (user_id, entry_date , email) 
		values ((select id from users where id = new.id) ,current_timestamp,(select email from users where email = new.email));
 		RETURN new;
 	end 
 $$ language plpgsql;

 create  trigger ins_trg after insert on users
 for each row execute procedure insert_user();


insert into users (firstName,lastName,email)
values('test','test','test@gmail.com');

select * from user_log;

select * from users;

select * from users left join user_log on users.id = user_log.user_id;

--update trigger

create or replace function update_users() returns trigger as $$
 	begin
 		update user_log set email = (select email from users where email = new.email),
		entry_date = current_timestamp
		WHERE user_id = old.id;
		 
	
 		RETURN old;
 	end 
 $$ language plpgsql;

 create trigger update_trigger after update on users
 for each row execute procedure update_users();
 
 select * from users;
 select * from user_log;
 
 
 update  users
 set email = 'Emirlan' where users.email = 'test@gmail.com';
 
--view and join
CREATE VIEW products_view AS
  SELECT product.*, price AS price_count
  FROM product
  LEFT OUTER JOIN (
    SELECT b.user_id, COUNT(*) price_count
    FROM   user_buy_product b
    GROUP BY b.user_id
  ) a ON a.user_id = product.id;
  
select * from products_view;
