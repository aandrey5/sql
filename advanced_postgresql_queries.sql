select product_name , category_id , size , price 
from inventory.products 
where price > 20.00;


select size as "product size" , count(*) as "number of products"
from inventory.products
group by size
having count(*) > 10
order by size desc;


select sku, product_name , "size" , price
from inventory.products ;


select product_name, 
	count(*) as "number of products", 
	max(price) as "highest price",
	max(size) as "larged size",
	min(price) as "lowest price",
	avg(price) as "average price" 
from inventory.products 
group by product_name;


select * from sales.customers;

select newsletter , count(*), max(newsletter) 
from sales.customers
group by newsletter ;


select s
	tate, 
	count(*), 
	bool_and(newsletter), -- if all received a letter - true,  if one- not - false
	bool_or(newsletter) -- if only one record is true - it will be true
from sales.customers
group by state ;


--==========================================================================
-- STATISTIC FUNC
--==========================================================================

select gender, count(*), avg(height_inches), min(height_inches), max(height_inches),
stddev_samp(height_inches) , -- % stand deviat general sovokupnost
stddev_pop(height_inches) ,-- % stand deviat - vyborka
var_samp(height_inches) , -- variation % general
var_pop(height_inches) 
from public.people_heights
group by gender ;



--==========================================================================
-- ROLLUP - SUBTOTALS and GRAND TOTALS
--==========================================================================


select 
	category_id ,
	product_name ,
	count(*),
	min(price) as "lowest price",
	max(price)	as "highest price" ,
	avg(price) as "average price"
from inventory.products
group by rollup (category_id , product_name )
order by category_id , product_name ;


select * from (
select 
	category_id ,
	product_name ,
	count(*),
	min(price) as "lowest price",
	max(price)	as "highest price" ,
	avg(price) as "average price"
from inventory.products
group by rollup (category_id , product_name )
order by category_id , product_name ) as tttl
where product_name is null;

--==========================================================================
-- CUBE COMPLETE - Independent analytics for second group
--==========================================================================



select 
	category_id ,
	size,
	count(*),
	min(price) as "lowest price",
	max(price)	as "highest price" ,
	avg(price) as "average price"
from inventory.products
group by cube (category_id , size )
order by category_id , size ;



--==========================================================================
-- SEGMENTING GROUPS WITH AGREGATE FILTERS - AS DAX XALCULATE MEASURES
--==========================================================================


select 
	category_id ,
	count(*) as "count all",
	avg(price) as "average price",
	-- small products
	count(*) filter (where size <= 16) as "count small",
	avg(price) filter (where size <= 16) as "average price small",
	-- large products
	count(*) filter (where size > 16) as "count large",
	avg(price) filter (where size > 16) as "average price large"
from inventory.products
group by rollup  (category_id  )
order by category_id ;


--==========================================================================
-- CHALLENGE
--==========================================================================
-- 1
select 
	customer_id,
	count(*) filter (where order_date >= '2021-04-01' and order_date <= '2021-04-30') as "april",
	count(*) filter (where order_date between '2021-03-01' and  '2021-03-31') as "march"
from sales.orders
group by  customer_id 
;
--  
select * from sales.order_lines ;



-- 2
select 
	sku ,
	sum(quantity) as "total quantity"
from sales.order_lines
group by rollup (sku)
order by sku;

--==========================================================================
--==========================================================================
-- WINDOW FUNC
--==========================================================================
--==========================================================================



--==========================================================================
-- WINDOW OVER
--==========================================================================

select  
	sku ,
	product_name ,
	size,
	price ,
	avg(price) over()
from inventory.products;
--group by category_id 

select  
	sku ,
	product_name ,
	size,
	price ,
	avg(price) 
from inventory.products;

-- Partition rows in window

select * from inventory.products;


select 
	sku,
	product_name ,
	category_id ,
	price ,
	size, 
	avg(price) over(partition by size) as "average price for size",
	price - avg(price) over(partition by size) as "difference"
from inventory.products
order by sku, "size" ;
	

-- Streamline PRTITION Queries
select 
	sku,
	product_name ,
	category_id ,
	size, 
	price ,
	avg(price) over (xyz),
	min(price) over (xyz),
	max(price) over (xyz)
from inventory.products 
window xyz as (partition by category_id)
order by sku, size;


--  ordering data partition 

select category_id,
	sum(category_id) over(order by category_id) as "running total"
from inventory.categories ;



select order_lines.order_id,
	order_lines.line_id,
	order_lines.sku,
	order_lines.quantity ,
	products.price as "price each",
	order_lines.quantity * products.price as "line total",
	sum(order_lines.quantity * products.price)
		over(partition by order_id) as "order total",
	sum(order_lines.quantity * products.price) 
		over(partition by order_id order by line_id) as "running total ",
	(sum(order_lines.quantity * products.price) 
		over(partition by order_id order by line_id) / sum(order_lines.quantity * products.price)
		over(partition by order_id) * 100 ) as "percent running total"
	
from sales.order_lines inner join inventory.products
	on order_lines.sku = products.sku;


	
	
-- mooving average with sloding window 

select 
	order_id,
	sum(order_id) over(order by order_id rows between 0 preceding and 2 following)
		as "3 period leading sum",
	sum(order_id) over(order by order_id rows between 2 preceding and 0 following)
		as "3 period trailing sum",
	avg(order_id) over(order by order_id rows between 1 preceding and 1 following)
		as "3 period moving average"
from sales.orders;


-- return values at specific locations within a window 

select 
	company ,
	first_value(company) over(order by company),
	last_value(company) over(order by company),
	nth_value(company, 3) over(order by company)
from sales.customers 
order by company;


Blue Vine	Blue Vine	Blue Vine	
Bread Express	Blue Vine	Bread Express	
Delish Food	Blue Vine	Delish Food	Delish Food
Flavorville	Blue Vine	Flavorville	Delish Food
Green Gardens	Blue Vine	Green Gardens	Delish Food
Wild Rose	Blue Vine	Wild Rose	Delish Food






