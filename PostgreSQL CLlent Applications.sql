createdb -h 000000000000*  -p 5432 -U postgres two_trees

psql -h 0000000000000 -p 5432 -U postgres -l

-- FIX CODING ERROR

The steps are:

open the cmd
SET PGCLIENTENCODING=utf-8
chcp 65001
psql -h your.ip.addr.ess -U postgres

-- EXECUTE COMMANDS

psql -h 80.87.200.251 -d two_trees -U postgres

--COONECTION INFO
two_trees=# \conninfo



-- HELP BUILT-IN DOCUMEMTATION

two_trees=# \h CREATE ROLE
Command:     CREATE ROLE
Description: define a new database role
Syntax:
CREATE ROLE name [ [ WITH ] option [ ... ] ]

where option can be:

      SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | REPLICATION | NOREPLICATION
    | BYPASSRLS | NOBYPASSRLS
    | CONNECTION LIMIT connlimit
    | [ ENCRYPTED ] PASSWORD 'password' | PASSWORD NULL
    | VALID UNTIL 'timestamp'
    | IN ROLE role_name [, ...]
    | IN GROUP role_name [, ...]
    | ROLE role_name [, ...]
    | ADMIN role_name [, ...]
    | USER role_name [, ...]
    | SYSID uid

URL: https://www.postgresql.org/docs/14/sql-createrole.html

-- SWITCH Between users

two_trees=# \c two_trees micah
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
You are now connected to database "two_trees" as user "micah".
two_trees=> \c - postgres
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
You are now connected to database "two_trees" as user "postgres".
two_trees=#


-- EXECUTE SQL FROM FILE

psql -h 80.87.200.251 -p 5432 -d two_trees -U postgres --file "C:\Users\am********\Downloads\PostgreSQL_Client_Applications\PostgreSQL_Client_Applications\Chapter 2\Two_Trees_Database.txt"




-- ADDITIONAL INFORMATION ABOUT DATABASES

two_trees=# \l+
                                                                 List of databases
     Name      |  Owner   | Encoding | Collate | Ctype |   Access privileges   |  Size   | Tablespace |                Description
---------------+----------+----------+---------+-------+-----------------------+---------+------------+--------------------------------------------
 demo          | postgres | LATIN1   | en_US   | en_US |                       | 2686 MB | pg_default |
 ods           | postgres | LATIN1   | en_US   | en_US |                       | 8401 kB | pg_default |
 old_two_trees | postgres | LATIN1   | en_US   | en_US |                       | 8945 kB | pg_default |
 postgres      | postgres | LATIN1   | en_US   | en_US |                       | 8569 kB | pg_default | default administrative connection database
 template0     | postgres | LATIN1   | en_US   | en_US | =c/postgres          +| 8401 kB | pg_default | unmodifiable empty database
               |          |          |         |       | postgres=CTc/postgres |         |            |
 template1     | postgres | LATIN1   | en_US   | en_US | =c/postgres          +| 8553 kB | pg_default | default template for new databases
               |          |          |         |       | postgres=CTc/postgres |         |            |
 two_trees     | postgres | LATIN1   | en_US   | en_US |                       | 8825 kB | pg_default |
(7 rows)

