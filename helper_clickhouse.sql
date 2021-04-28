______________________________________
-- ClickHouse myHELPER
______________________________________

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
