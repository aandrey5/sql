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
  
  
  
