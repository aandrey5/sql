______________________________________
-- ClickHouse myHELPER
______________________________________

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Create table as select all from another table

create table dwh.rnc_dump14092021 
ENGINE = Log   
as 
select * from dwh.rnc;

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


sudo clickhouse start

clickhouse-client

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
-- When executing command $ sudo reboot. When OS boot tries to connect to server CH. But get the error:

$ clickhouse-client
ClickHouse client version 1.1.54385.
Connecting to localhost:9000.
Code: 210. DB::NetException: Connection refused: (localhost:9000, ::1)
OS: ubuntu 16.04
clean install
<listen_host>::</listen_host> - is work...
log:

IF YOU UNCOMMENT AND COMMENT LINE AFTER, BE SHURE TO SET --> IN END !!!
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


Установк конкретной версии

sudo apt-get install clickhouse-server=20.8.8.2 clickhouse-client=20.8.8.2 clickhouse-common-static=20.8.8.2


Force remove

---------------------------------------------------------------------------------------------------------
IMPORT DATA FROM PostgreSQL 
---------------------------------------------------------------------------------------------------------
-- worked!

create table dwh.sales_db
	(distr String,
		year String,
		month String,
		sum_sale_no_nds Float64
		)
engine = PostgreSQL('10.128.100.98:5432', 'dwh', 'copy001', 'airflow_xcom', '1q2w3e4r5T')
