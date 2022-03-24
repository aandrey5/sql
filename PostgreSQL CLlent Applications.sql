createdb -h 000000000000*  -p 5432 -U postgres two_trees

psql -h 0000000000000 -p 5432 -U postgres -l

-- FIX CODING ERROR

The steps are:

open the cmd
SET PGCLIENTENCODING=utf-8
chcp 65001
psql -h your.ip.addr.ess -U postgres
