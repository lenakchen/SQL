/*** 

To enable the launchd service, you can either:

Click Start MySQL Server from the MySQL preference pane.

Or, manually load the launchd file. (not working)

shell> cd /Library/LaunchDaemons
shell> sudo launchctl load -F com.oracle.oss.mysql.mysqld.plist

***/
/** add alias to start mysql manually
alias mysql=/usr/local/mysql/bin/mysql
alias mysqlstart='sudo /usr/local/mysql/support-files/mysql.server start'
alias mysqlstop='sudo /usr/local/mysql/support-files/mysql.server stop'
alias mysqlstatus="ps aux | grep mysql | grep -v grep"      


shell> mysqlstart
shell> mysql
shell> mysqlstop

##Aug 2016: Got Error Msg when using "mysqlstop"
## sudo modify /usr/local/mysql/my.cnf
# add PID file in on Aug 2016 to fix "MySQL server PID file could not be found"
pid-file = /usr/local/mysql/data/Kelings-MacBook-Air.local.pid
## then "mysqlstop" shut down MYSQL server successfully


# log in mysql as root 
shell> mysql -u root
# and set up password
mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpwd');
mysql> SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('newpwd');
mysql> SET PASSWORD FOR 'root'@'::1' = PASSWORD('newpwd');
mysql> SET PASSWORD FOR 'root'@'host_name' = PASSWORD('newpwd');
***/

/*** Practice using schema and data from Stanford DB course ***/
mysql> create database schoolDB;

/* Creating a database does not select it for use; you must do that explicitly. */
mysql> use schoolDB;
mysql> show tables;

/* Creating tables using an existing schema file. */
mysql> source Schema.sql
mysql> source Data.sql;


/* you can create new database under the current database and then 'use new_database;'
to switch to new database */

/* Update one cell in table */
UPDATE mytable
    SET column_name1 = value1,
        column_name2 = value2
    WHERE key_value = some_value;
    
    

