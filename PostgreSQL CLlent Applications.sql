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




