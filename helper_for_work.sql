___________________________________
--------PostgreSQL myHELPER--------
___________________________________



-- посмотреть дубли (поздние)
select * from (select *, 
	ROW_NUMBER() over (partition by xxxxxxxxxxxx, xxxxxxxxxxxx  order by xxxxxxxxxxxx, xxxxxxxxxxxx) as rannkk
from xxx.xxxxxxxxxxxx) as duppl
where rannkk = 2
;


delete from xxx.xxxxxxxxxxxx 
using 
(select *, 
	ROW_NUMBER() over (partition by xxxxxxxxxxxx, xxxxxxxxxxxx  order by xxxxxxxxxxxx, xxxxxxxxxxxx) as rannkk
from xxx.xxxxxxxxxxxx) as duppl
where rannkk = 2) fff;


-- Удаление дубликатов быстро

DELETE FROM xxx.xxxxxxxxxxxx a USING (
      SELECT MIN(ctid) as ctid, nnnnnnn
        FROM xxx.xxxxxxxxxxxx 
        GROUP BY nnnnnnn HAVING COUNT(*) > 1
      ) b
      WHERE a.nnnnnnn = b.nnnnnnn
      AND a.ctid <> b.ctid;




-- LIST OF ALL TABLES
-- Список всех таблиц во всех схемах


select
	table_name
from
	information_schema.tables
where
	table_schema not in ('information_schema', 'pg_catalog');


-- LIST OF ALL TABLES OF SCHEMA 'nnn'
-- Список всех таблиц во всех схемах



select
	table_name
from
	information_schema.tables
where
	table_schema = 'nnn';


-- LIST OF ALL TABLES



---SQL Server ---- 
Sort by ordinal positions of columns

SQL Server allows you to sort the result set based on the ordinal positions of columns that appear in the select list.

The following statement sorts the customers by first name and last name. But instead of specifying the column names explicitly, it uses the ordinal positions of the columns:

SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    1,
    2;

------------------------------------------------------------
-- optimisation
-- create extension before this

SELECT *
FROM
  pg_stat_statements
ORDER BY
  total_exec_time DESC;


-- SELECT TOP-20

SELECT substring(query, 1, 50) AS short_query,
              round(total_exec_time::numeric, 2) AS total_exec_time,
              calls,
              round(mean_exec_time::numeric, 2) AS mean,
              round((100 * total_exec_time / sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage_cpu
FROM  pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 20;





-- window func
-- row_number
select 
	brand, 
	mirta_name, 
	row_number() OVER (order by mirta_name asc) AS num 
from sales_db_copy
group by brand, mirta_name


-- row_number partition by
select 
	brand, 
	mirta_name, 
	row_number() OVER (partition by brand order by mirta_name asc) AS num 
from sales_db_copy
group by brand, mirta_name


-- rank
select 
	brand, 
	mirta_name, 
	rank() OVER (partition by brand order by mirta_name asc) AS num 
from sales_db_copy
group by brand, mirta_name



-- sum
SELECT
    transaction_id,
    change,
    sum(change) OVER (ORDER BY transaction_id) as balance
FROM balance_change 
ORDER BY transaction_id;


select 
	brand, 
	mirta_name, 
	sum(sum_sale_no_nds) OVER (order by mirta_name asc) AS summm 
from sales_db_copy
group by brand, mirta_name, sum_sale_no_nds



-- sum and others

select 
	brand, 
	mirta_name, 
	sum(sum_sale_no_nds) as sum_sku,
	sum(sum_sale_no_nds) OVER (partition by brand order by mirta_name asc) AS summm,
	 round(100 * (sum(sum_sale_no_nds::double precision) / sum(sum_sale_no_nds::double precision) OVER (partition by brand order by mirta_name asc))) as prsnt
from sales_db_copy
group by brand, mirta_name, sum_sale_no_nds



-- foreign keys
CREATE TABLE Customers
(
    Id SERIAL PRIMARY KEY,
    Age INTEGER, 
    FirstName VARCHAR(20) NOT NULL
);
  
CREATE TABLE Orders
(
    Id SERIAL PRIMARY KEY,
    CustomerId INTEGER,
    Quantity INTEGER,
    FOREIGN KEY (CustomerId) REFERENCES Customers (Id)
);


-- list current the sessions

SELECT usename, client_addr, backend_start FROM pg_stat_activity WHERE datname = 'dwh';

-- reset all sessions except me

SELECT pg_terminate_backend( pid ) FROM pg_stat_activity WHERE pid <>
pg_backend_pid( ) AND datname = 'dwh';



-- copy table all

create table sales_db_copy as
  select * from sales_db;
  
  
 -- This will create the table with all the data, but without indexes and triggers etc.
 create table my_table_copy as
  select * from my_table
with no data

-- The create table like syntax will include all triggers, indexes, constraints, etc. But not include data.
create table my_table_copy (like my_table including all)


-- update in transaction
begin;

update 
	sales_db_copy
set price_grotex_no_nds = replace(price_grotex_no_nds, ',', '.');



-- safety replace / update
begin;
update 
	sales_db_copy
set 
	price_ru_nds = replace(price_ru_nds, ',', '.'),
	rc_grotex_nds = replace(rc_grotex_nds, ',', '.'),
	deviation_rc = replace(deviation_rc, ',', '.'),
	sum_price_grtx_nds = replace(sum_price_grtx_nds, ',', '.'),
	sum_price_grtx_no_nds = replace(sum_price_grtx_no_nds, ',', '.'),
	sum_purchase_nds = replace(sum_purchase_nds, ',', '.'),
	sum_purchase_no_nds = replace(sum_purchase_no_nds, ',', '.'),
	sum_sale_nds = replace(sum_sale_nds, ',', '.'),
	sum_sale_no_nds = replace(sum_sale_no_nds	, ',', '.'),
	sumdiscount = replace(sumdiscount, ',', '.'),
	sum_vat = replace(sum_vat, ',', '.'),
	margin_percent = replace(margin_percent, ',', '.');
	
commit;



-- change data types in column from var char to double precision

alter table sales_db_copy
alter column quant_box type double precision
USING quant_box::double precision;



-- multiple altering columns

begin;

alter table sales_db_copy

alter column rc_grotex_nds type double precision
USING rc_grotex_nds::double precision,


alter column price_ru_nds type double precision
USING price_ru_nds::double precision,

alter column deviation_rc type varchar(20)
USING deviation_rc::varchar(20),

alter column quant_box type double precision
USING quant_box::double precision,

alter column sum_price_grtx_nds type double precision
USING sum_price_grtx_nds::double precision,

alter column quant_box type double precision
USING quant_box::double precision,

alter column sum_price_grtx_no_nds type double precision
USING sum_price_grtx_no_nds::double precision,

alter column sum_purchase_nds type double precision
USING sum_purchase_nds::double precision,

alter column sum_purchase_no_nds type double precision
USING sum_purchase_no_nds::double precision,

alter column sum_sale_nds type double precision
USING sum_sale_nds::double precision,

alter column sum_sale_no_nds type double precision
USING sum_sale_no_nds::double precision,

alter column sumdiscount type double precision
USING sumdiscount::double precision,

alter column sum_vat type double precision
USING sum_vat::double precision,

alter column margin_percent type varchar(20)
USING margin_percent::varchar(20);

commit;


-- dividing counted columns

select 
	distr,
	sum(sum_sale_no_nds) as no_nds,
	sum(sum_sale_nds) as s_nds,
	(sum(sum_sale_nds)-sum(sum_sale_no_nds)) as nds,
	((sum(sum_sale_nds)-sum(sum_sale_no_nds)) / sum(sum_sale_no_nds))*100 as nds_percent 
	
from sales_db_copy
group by distr;

							
-- PowerBI to Materialized view PostgreSQL
							
RE: Materialized views in PostgreSQL
Mathieu Jehanno on 7/5/2020 11:39:38 PM
'You can access to a materialized view in PostGre by writing a request like that' :

= public_Schema{[Name="XXXXX",Kind="View"]}[Data]

Tip: create first a new source and then just change the table name XXXXX
-----------------------------------------------------------------------------------
  
  

RE: Materialized views in PostgreSQL
Koen on 7/5/2020 11:03:08 PM
Same issue here. Easy but not so great work around: create another nrmal view with select * from the materialized view
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------;	
					
-----------------------------------------------------------------------------------;
VIEW TABLE SCHEMA							
-----------------------------------------------------------------------------------;
							
														
SELECT
   table_name,
   column_name,
   data_type
FROM
   information_schema.columns
WHERE
   table_name = 'copy001';

							
							
SELECT
   table_name,
   column_name,
   data_type
FROM
   information_schema.columns
WHERE
   table_name = 'copy001' and data_type = 'double precision' ;	
							
							
					
-- delete raws
							
delete from copy001
where "year" = '2021' and "month" = 'Март';
							
							
-- size of all tables in database

\c dwh
							
SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_relation_size(C.oid)) AS "size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
  ORDER BY pg_relation_size(C.oid) DESC;		
  
  
  
  
  
-- create copy of table -- LIKE ---
  
CREATE TABLE flights_copy(LIKE flights)
WITH (autovacuum_enabled = false);


-- INSERT - SELECT ----

INSERT INTO flights_copy SELECT * FROM flights;


-- SEE STATISTICS --

 SELECT reltuples, relpages, relallvisible
FROM pg_class WHERE relname = 'flights_copy';



-- COLLECT STATISTICS ))) ----------
ANALYZE flights_copy;



-- UPDATE relallvisible --
VACUUM flights_copy;


-- KILL SESSIONS postgreSQL

root@aandrey5:~# sudo kill -9 525073
root@aandrey5:~# ps -ef | grep postgres
postgres  524700       1  0 12:26 ?        00:00:00 /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/14/main -c config_file=/etc/postgresql/14/main/postgresql.conf
postgres  525082  524700  0 12:57 ?        00:00:00 postgres: 14/main: checkpointer
postgres  525083  524700  0 12:57 ?        00:00:00 postgres: 14/main: background writer
postgres  525084  524700  0 12:57 ?        00:00:00 postgres: 14/main: walwriter
postgres  525085  524700  0 12:57 ?        00:00:00 postgres: 14/main: autovacuum launcher
postgres  525086  524700  0 12:57 ?        00:00:00 postgres: 14/main: stats collector
postgres  525087  524700  0 12:57 ?        00:00:00 postgres: 14/main: logical replication launcher
postgres  525088  524700  4 12:57 ?        00:00:00 postgres: 14/main: postgres two_trees 109.230.162.208(56965) SELECT
root      525090  524126  0 12:57 pts/0    00:00:00 grep --color=auto postgres
root@aandrey5:~# ps -ef | grep postgres
postgres  524700       1  0 12:26 ?        00:00:00 /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/14/main -c config_file=/etc/postgresql/14/main/postgresql.conf
postgres  525082  524700  0 12:57 ?        00:00:00 postgres: 14/main: checkpointer
postgres  525083  524700  0 12:57 ?        00:00:00 postgres: 14/main: background writer
postgres  525084  524700  0 12:57 ?        00:00:00 postgres: 14/main: walwriter
postgres  525085  524700  0 12:57 ?        00:00:00 postgres: 14/main: autovacuum launcher
postgres  525086  524700  0 12:57 ?        00:00:00 postgres: 14/main: stats collector
postgres  525087  524700  0 12:57 ?        00:00:00 postgres: 14/main: logical replication launcher
root      525096  524126  0 12:57 pts/0    00:00:00 grep --color=auto postgres
root@aandrey5:~# sudo -u postgres psql

							
