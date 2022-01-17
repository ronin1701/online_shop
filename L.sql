
----delete trigger

create or replace function delete_audit() returns trigger 
 as $$
 	BEGIN
 		delete from audit
		WHERE user_id = (select id from users where users.id = old.id) ;
 		return old;
 	END
 $$ language plpgsql;

 create  trigger delete_audit_trigger before delete on users
 for each row execute procedure delete_audit();


select * from audit;

delete from users 
where id  = 31;
----------------------------------------------------------------insert trigger
