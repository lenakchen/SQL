create database computerfirm;

drop table if exists Product;
drop table if exists PC;
drop table if exists Laptop;
drop table if exists Printer;

create table Product(maker varchar(10), model varchar(50), type varchar(50));
create table PC(code int, model varchar(50), speed smallint, ram smallint, hd real, cd varchar(10), price money);
create table Laptop(code int, model varchar(50), speed smallint, ram smallint, hd real, price money, screen smallint);
create table Printer(code int, model varchar(50), color char(1), type varchar(10), price money);


delete from Product;
delete from PC;
delete from Laptop;
delete from Printer;

insert into Product values ('A', '1232', 'PC');
insert into Product values ('A', '1233', 'PC');
insert into Product values ('A', '1276', 'Printer');
insert into Product values ('A', '1298', 'Laptop');
insert into Product values ('A', '1401', 'Printer');
insert into Product values ('A', '1408', 'Printer');
insert into Product values ('A', '1752', 'Laptop');
insert into Product values ('B', '1121', 'PC');
insert into Product values ('B', '1750', 'Laptop');
insert into Product values ('C', '1321', 'Laptop');
insert into Product values ('D', '1288', 'Printer');
insert into Product values ('D', '1433', 'Printer');
insert into Product values ('E', '1260', 'PC');
insert into Product values ('E', '1434', 'Printer');
insert into Product values ('E', '2112', 'PC');
insert into Product values ('E', '2113', 'PC');


insert into PC values (1, '1232', '500', '64', 5.0, '12x', 600.0000);
insert into PC values (2, '1121', '750', '128',	14.0, '40x', 850.0000);
insert into PC values (3, '1233', '500', '64', 5.0,	'12x', 600.0000);
insert into PC values (4, '1121', '600', '128',	14.0, '40x', 850.0000);
insert into PC values (5, '1121', '600', '128',	8.0, '40x',	850.0000);
insert into PC values (6, '1233', '750', '128',	20.0, '50x', 950.0000);
insert into PC values (7, '1232', '500', '32', 10.0, '12x',	400.0000);
insert into PC values (8, '1232', '450', '64', 8.0, '24x', 350.0000);
insert into PC values (9, '1232', '450', '32', 10.0, '24x',	350.0000);
insert into PC values (10, '1260', '500', '32', 10.0, '12x', 350.0000);
insert into PC values (11, '1233', '900', '128', 40.0, '40x', 980.0000);
insert into PC values (12, '1233', '800', '128', 20.0, '50x', 970.0000);

insert into Laptop values (1, '1298', '350', '32', 4.0, 700.0000, '11');
insert into Laptop values (2, '1321', '500', '64', 8.0,	970.0000, '12');
insert into Laptop values (3, '1750', '750', '128',	12.0, 1200.0000, '14');
insert into Laptop values (4, '1298', '600', '64', 10.0, 1050.0000, '15');
insert into Laptop values (5, '1752', '750', '128',	10.0, 1150.0000, '14');
insert into Laptop values (6, '1298', '450', '64', 10.0, 950.0000, '12');

insert into Printer values (1, '1276', 'n',	'Laser', 400.0000);
insert into Printer values (2, '1433', 'y',	'Jet', 270.0000);
insert into Printer values (3, '1434', 'y',	'Jet', 290.0000);
insert into Printer values (4, '1401', 'n',	'Matrix', 150.0000);
insert into Printer values (5, '1408', 'n', 'Matrix', 270.0000);
insert into Printer values (6, '1288', 'n', 'Laser', 400.0000);


/* Product Table
maker	model	type
A	1232	PC
A	1233	PC
A	1276	Printer
A	1298	Laptop
A	1401	Printer
A	1408	Printer
A	1752	Laptop
B	1121	PC
B	1750	Laptop
C	1321	Laptop
D	1288	Printer
D	1433	Printer
E	1260	PC
E	1434	Printer
E	2112	PC
E	2113	PC 
*/




/* PC Table
code model speed ram hd	    cd	price
1	 1232	500	 64	  5.0	12x	600.0000
10	 1260	500	 32	  10.0	12x	350.0000
11	 1233	900	 128  40.0	40x	980.0000
12	 1233	800	 128  20.0	50x	970.0000
2	 1121	750	 128  14.0	40x	850.0000
3	 1233	500	 64	  5.0	12x	600.0000
4	 1121	600	 128  14.0	40x	850.0000
5	 1121	600	 128  8.0	40x	850.0000
6	 1233	750	 128  20.0	50x	950.0000
7	 1232	500	 32	  10.0	12x	400.0000
8	 1232	450	 64	  8.0	24x	350.0000
9	 1232	450	 32	  10.0	24x	350.0000
*/

/* Laptop Table
code	model	speed	ram	hd	price	screen
1	1298	350	32	4.0	700.0000	11
2	1321	500	64	8.0	970.0000	12
3	1750	750	128	12.0	1200.0000	14
4	1298	600	64	10.0	1050.0000	15
5	1752	750	128	10.0	1150.0000	14
6	1298	450	64	10.0	950.0000	12
*/

/* Printer Table
code	model	color	type	price
1	1276	n	Laser	400.0000
2	1433	y	Jet	270.0000
3	1434	y	Jet	290.0000
4	1401	n	Matrix	150.0000
5	1408	n	Matrix	270.0000
6	1288	n	Laser	400.0000
*/