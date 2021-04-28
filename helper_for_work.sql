___________________________________
--------PostgreSQL myHELPER--------
___________________________________

-- copy table all

create table sales_db_copy as
  select * from sales_db;
  
  
 -- This will create the table with all the data, but without indexes and triggers etc.
 create table my_table_copy as
  select * from my_table
with no data

-- The create table like syntax will include all triggers, indexes, constraints, etc. But not include data.
create table my_table_copy (like my_table including all)
  
  
  
