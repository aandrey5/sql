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


select 
	company ,
	first_value(company) over(order by company
		rows between unbounded preceding and unbounded following),
	last_value(company) over(order by company
		rows between unbounded preceding and unbounded following),
	nth_value(company, 3) over(order by company
		rows between unbounded preceding and unbounded following)
from sales.customers 
order by company;

select * from sales.orders;

-- first and lact date of order
select distinct  customer_id,
	first_value(order_date)
		over(partition by  customer_id
		order by order_date
		rows between unbounded preceding and unbounded following),
	last_value(order_date)
		over(partition by  customer_id
		order by order_date
		rows between unbounded preceding and unbounded following)
from sales.orders
order by customer_id ;


-- CHALLENGE 2

select * from inventory.products p ;

select 
	product_name,
	category_id ,
	size,
	price as "each price",
	min(price) over(calc) as "min price",
	max(price) over(calc) as "max price",
	avg(price) over(calc) as "avg price",
	count(*) over(partition by category_id) as "total counts of cat products",
	count(*) over(partition by size) as "total counts of size products"
from inventory.products
window calc as (partition by product_name);
	

select 
	product_name,
	category_id ,
	size,
	price as "each price",
	min(price) over(calc) as "min price",
	max(price) over(calc) as "max price",
	avg(price) over(calc) as "avg price",
	count(*) over(calc) as "total counts of cat products"
from inventory.products
window calc as (partition by category_id, size)
order by category_id, product_name, size;
;

	
	
--==========================================================================
--==========================================================================
-- STATISTIC FUNC
--==========================================================================
--==========================================================================


select * from inventory.products;

select * from inventory.categories c ;

with tbbl as (select 
	p.product_name,
	p.sku,
	p.price
from inventory.products p 
inner join  inventory.categories c
	on c.category_id  = p.category_id)
select * from tbbl 
where tbbl.product_name = 'Delicate';

select product_name ro from inventory.products;

create table dbbl as select product_name  from inventory.products;

drop table dbbl;


select * from dbbl;

delete from dbbl;


insert into dbbl (product_name)
values 
('Light'),
('Light'),
('Manzanilla'),
('Manzanilla'),
('Mission'),
('Moraiolo'),
('Oblica'),
('Pendolino'),
('Pendolino'),
('Picual'),
('Pure'),
('Pure'),
('Refined'),
('Virgin'),
('Mandarin-Infused'),
('Lemon-Infused')
;


select 
	product_name
from dbbl
group by product_name
having count(*) > 1
;


select height_inches 
from public.people_heights
order by height_inches ;


-- MEDIAN VALUE

select 
	gender,
	percentile_disc(0.5) within group (order by height_inches) as "discrete median",
	percentile_cont(0.5) within  group (order by height_inches) as "continious median"
from public.people_heights
group by rollup (gender) 
;


-- FIRST AND THIRD QUANTILES

select height_inches 
from public.people_heights
order by height_inches ;


-- first quartile
select 
	percentile_cont(.25) within group (order by height_inches) as "1st qartile",
	percentile_cont(.50) within group (order by height_inches) as "2st qartile",
	percentile_cont(.75) within group (order by height_inches) as "3st qartile"
from public.people_heights;


-- devide data to 4 groups (not real 4 quartiles)

select 
	name,
	height_inches ,
	ntile(4) over(order by height_inches)
from public.people_heights
order by height_inches ;

-- MOST FREQUENT VALUE with MODE

select 
	mode() within group (order by height_inches)
from public.people_heights;

-- the MODE FUNC has a BIG PROBLEM (SEE BELOW)
select height_inches , count(*) 
from public.people_heights
group by height_inches 
order by count(*) desc;


-- Determine the range of values within a dataset

select 
	gender,
	max(height_inches) - min(height_inches) as  "height range"
from public.people_heights
group by rollup (gender);


-- CHALENGE

select * from inventory.products p ;

select 
	product_name ,
	size,
	price,
	-- min(price) as "minimum total",
	-- max(price) as "maximum total",
	min(price) over(part_prod) as "min in partition",
	max(price) over(part_prod) as "max in partition",
	max(price) over(part_prod)  - min(price) over(part_prod) as "price range",
	percentile_cont(.25) within group (order by price) "1st qartile",
	percentile_cont(.50) within group (order by price) "2st qartile",
	percentile_cont(.75) within group (order by price) "3st qartile"
	-- max(price) - min(price) over(part_prod) as  "price range"
from inventory.products
group by (product_name, size, price)
window part_prod as (partition by size)
order by "size"
;


-- NOT WORKED
select 
	category_id ,
	-- min(price) as "minimum total",
	-- max(price) as "maximum total",
	min(price) over(part_prod) as "min in partition",
	max(price) over(part_prod) as "max in partition",
	max(price) over(part_prod)  - min(price) over(part_prod) as "price range",
	percentile_cont(.25) within group (order by price) "1st qartile",
	percentile_cont(.50) within group (order by price) "2st qartile",
	percentile_cont(.75) within group (order by price) "3st qartile"
	-- max(price) - min(price) over(part_prod) as  "price range"
from inventory.products
group by rollup (category_id)
window part_prod as (partition by category_id)
;

-- DESICION
-- Obtain sttistical info

select 
	category_id ,
	min(price) as "min price",
	percentile_cont(.25) within group (order by price) "1st qartile",
		percentile_cont(.50) within group (order by price) "2st qartile",
	percentile_cont(.75) within group (order by price) "3st qartile",
	max(price) as "max price",
	max(price) - min(price) as "price range"
from inventory.products
group by rollup (category_id);




--==========================================================================
--==========================================================================
-- RANKING FUNC
--==========================================================================
--==========================================================================


-- ORDER BY

select 
	name,
	height_inches,
	rank() over(order by height_inches desc),
	dense_rank() over(order by height_inches desc)
from public.people_heights
order by height_inches  desc;


-- PARTITION BY ORDER by 

select 
	name,
	height_inches,
	gender,
	rank() over(partition by gender order by height_inches desc),
	dense_rank() over(partition by gender order by height_inches desc)
from public.people_heights
order by gender, height_inches desc;



-- FIND  A HYPOTETICAL RANK

select 
	name,
	height_inches
from public.people_heights
order by height_inches  desc;


-- DECIDE WHICH POSITION  WILL BE FOR AN OUR VALUE IN RANK()

select 
	rank(75) within group (order by height_inches desc)
from public.people_heights;

-- DECIDE WHICH POSITION  WILL BE FOR DIFFERENT GROUPS IN GROUP BY CLASS

select 
	gender,
	rank(70) within group (order by height_inches desc)
from public.people_heights
group by rollup(gender);




-- TOP PERFORMERS WITH PERCENTILE RANKS

select 
	name,
	gender,
	height_inches,
	percent_rank() over(order by height_inches desc),
	case 
		when percent_rank() over(order by height_inches desc) < .25 then '1st'
		when percent_rank() over(order by height_inches desc) < .50 then '2st'
		when percent_rank() over(order by height_inches desc) < .75 then '3st'
		else '4th'
	end as "quartile rank"
from public.people_heights
order by height_inches desc;


-- evaluate propability with cumulative distribution

select 
	name,
	gender,
	height_inches,
	percent_rank() over(order by height_inches desc),
	cume_dist() over( order by height_inches desc)
from public.people_heights
order by height_inches desc;


-- CHALLENGE 

-- display ranking overall, segmented by category and by size

select * from inventory.products;

select 
	product_name,
	category_id ,
	size ,
	price,
	rank() over(partition by category_id, size order by price asc),
	dense_rank() over(partition by category_id, size order by price asc)
from inventory.products
order by category_id, size;


-- SOLUTION

select 
	product_name,
	category_id ,
	size ,
	price,
	dense_rank() over(order by price desc) as  "rank overall",
	dense_rank() over(partition by category_id order by price desc) as "rank category",
	dense_rank() over(partition by size order by price desc) as "rank size"
from inventory.products
order by category_id, price desc;



--==========================================================================
--==========================================================================
-- DEFINE VALUES WITH CASE STATEMENTS
--==========================================================================
--==========================================================================

select 
	 case 
	 	when 0 = 0 
	 	then 'A'
	 	when 1 = 1
	 	then 'B'
	 	else 'C'
	 end;
	 	
select * from inventory.products;


select 
	sku,
	product_name ,
	category_id ,
	case 
		when category_id = 1 then 'Olive Oils'
		when category_id = 2 then 'Flavour Infused Oils'
		when category_id = 3 then 'Bath and Beauty'
		else 'category unknown'
	end as "category description", 
	size, price
from inventory.products;


-- MERGE COLUMNS - COALESCE (IF ANOTHER IS NULL)

select coalesce (null, null, 'C');

select * from inventory.categories;	

insert into inventory.categories values 
(4, null, 'Gift Baskets');


select 
	category_id ,
	coalesce (category_description, product_line) as "description",
	product_line 
from inventory.categories;

