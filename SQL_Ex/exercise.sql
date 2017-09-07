/*Exercise: 14 (Serge I: 2012-04-20)
Get the makers producing more than one model, with models manufactured by each 
maker being products of the same type.
Result set: maker, type */

/*** Exercise: 19 (Serge I: 2003-02-13)
For each maker having models in the Laptop table, find out the average screen 
size of the laptops he produces. 
Result set: maker, average screen size. ***/

select maker, avg(screen) 
from Product, Laptop
where Product.model = Laptop.model
group by maker;

/* correct query:
Maker	Avg_screen
A	13
B	14
C	12
*/

/*Exercise: 20 (Serge I: 2003-02-13) Find the makers producing at least three 
distinct models of PCs.
Result set: maker, number of PC models.*/ 
/*** note that some models in Product do not exist in PC ***/

select distinct maker, count(model)
from Product
where type = 'PC'
group by maker
having count(model) >=3;

/* correct query: 
maker	
E	3
*/

/* Exercise: 21 (Serge I: 2003-02-13)
Find out the maximal PC price for each maker having models in the PC table. 
Result set: maker, maximal price. */
select maker, max(price) as max_price
from Product, PC
where Product.model = PC.model
group by maker

/*Exercise: 22 (Serge I: 2003-02-13): For each value of PC speed that exceeds 
600 MHz, find out the average price of PCs with identical speeds.
Result set: speed, average price.*/
select speed, avg(price)
from PC
where speed > '600'
group by speed

/*Exercise: 23 (Serge I: 2003-02-14)
Get the makers producing both PCs having a speed of 750 MHz or higher and laptops 
with a speed of 750 MHz or higher. 
Result set: maker */
select distinct maker 
from Product
where maker in (select maker from Product, PC where Product.model = PC.model and speed >= 750)
and maker in (select maker from Product, Laptop where Product.model = Laptop.model and speed >= 750);

SELECT maker
FROM product, PC
WHERE PC.model = product.model AND speed >= 750
INTERSECT
SELECT maker
FROM product, Laptop
WHERE Laptop.model = product.model AND speed >= 750;

/*Exercise: 24 (Serge I: 2003-02-03)
List the models of any type having the highest price of all products present in 
the database.*/

with hp as
(select model, price from PC
union
select model, price from Laptop
union
select model, price from Printer)
select model from hp
where hp.price = (select MAX(price) from hp);

WITH Model_MAX (model, max_price) AS (
SELECT model, price FROM PC
UNION 
SELECT model, price FROM Laptop
UNION 
SELECT model, price FROM Printer )
SELECT DISTINCT model FROM Model_MAX
WHERE max_price = (SELECT MAX(max_price) FROM Model_MAX);


/* Exercise: 25 (Serge I: 2003-02-14)
Find the printer makers which also produce PCs with the lowest RAM 
and the highest-speed processor among PCs with the lowest RAM. Result set: maker.*/

with P as
(select maker, speed 
from Product, PC
where Product.model = PC.model and ram = (select min(ram) from PC))
select maker from P
where speed = (select max(speed) from P)
intersect
select distinct maker from Product where type='Printer';


select distinct maker from Product 
where type='Printer'
and maker in (
select maker from Product
where model in (
select model from 
(select model, max(speed) from PC
where ram = (select min(ram) from PC)
group by model) P 
));


/*Exercise: 26 (Serge I: 2003-02-14)
Define the average price of the PCs and laptops produced by maker A.
Result set: single total price.*/ /*** note: difference between 'union' 
and 'union all' ***/
select sum(price)/count(price)
from 
(select price
from Product, PC
where Product.model = PC.model and maker = 'A'
union all
select price
from Product, Laptop
where Product.model = Laptop.model and maker = 'A') P;

/*The difference between Union and Union all is that Union all will not eliminate 
duplicate rows, instead it just pulls all rows from all tables fitting your query 
specifics and combines them into a table. A UNION statement effectively does a 
SELECT DISTINCT on the results set.*/
/* note: avg(price) not working here. because the datatype of price is money. 
\df <function_name> */
select avg(price) from
(
select price from pc where model in (select model from product where maker='A')
union all
select price from laptop where model in (select model from product where maker='A')
) as a;


/* Exercise: 27 (Serge I: 2003-02-03)
Define the average size of the PC hard drive for each maker that also produces printers.
Result set: maker, average capacity of HD. */
with P as (
select maker, hd
from Product, PC
where Product.model = PC.model
and maker in
(select maker from Product where type = 'Printer')
)
select maker, avg(hd)
from P
group by maker


/**************************************************************
  Short database description "Painting":
  
**************************************************************/

/* Exercise: 28 (Serge I: 2015-03-20)
To within two decimal digits, define the average quantity of paint per square. */
SELECT cast(SUM(case when UB.B_VOL IS NULL then 0 else UB.B_VOL end) /cast(COUNT(DISTINCT UQ.Q_ID) as float) as decimal(8,2))FROM utQ AS UQ
    LEFT JOIN utB AS UB ON UQ.Q_ID = UB.B_Q_ID

SELECT CAST(CASE WHEN SUM(B_VOL) >  0 THEN SUM(B_VOL) ELSE 0 END * 1.0 / (SELECT COUNT(*) FROM utQ) 
AS NUMERIC(6,2)) avg_paint
FROM utB

select cast(sum(case when B_VOL IS NULL then 0 else B_VOL end) * 1.0/ (select count(Q_ID) from utQ) as decimal(8,2))
from utB /*failed on third checking database*/

/* 386.25 */


/*******************************************************************
	Short database description "Recycling firm":
The firm has a few outlets that receive items for recycling. 
Each of the outlets receives funds to be paid to deliverers. 

Information on received funds is registered in a table:
Income_o(point, date, inc)
The primary key is (point, date), thus receiption of money (inc) takes place not more 
than once a day (date column does not include time component of the date). 

Information on payments to deliverers is registered in the table:
Outcome_o(point, date, out)
In this table the primary key (point, date) also ensures bookkeeping of the funds 
distribution at each point not more than once a day.
In case incomes and expenses may occur more than once a day, another database schema is used. 

Corresponding tables include code column as primary key:
Income(code, point, date, inc)
Outcome(code, point, date, out)
In this schema date column does not also include the day time.
********************************************************************/

