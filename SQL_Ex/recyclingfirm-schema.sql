/****************
The firm has a few outlets that receive items for recycling. 
Each of the outlets receives funds to be paid to deliverers. 
Information on received funds is registered in a table:
Income_o(point, date, inc)
The primary key is (point, date), thus receiption of money (inc) takes place not more than once a day (date column does not include time component of the date). 
Information on payments to deliverers is registered in the table:
Outcome_o(point, date, out)
In this table the primary key (point, date) also ensures bookkeeping of the funds distribution at each point not more than once a day.
In case incomes and expenses may occur more than once a day, another database schema is used. 
Corresponding tables include code column as primary key:
Income(code, point, date, inc)
Outcome(code, point, date, out)
In this schema date column does not also include the day time.
*/

/* Income_o
point		date			inc
1	2001-03-22 00:00:00.000	15000.0000
1	2001-03-23 00:00:00.000	15000.0000
1	2001-03-24 00:00:00.000	3400.0000
1	2001-04-13 00:00:00.000	5000.0000
1	2001-05-11 00:00:00.000	4500.0000
2	2001-03-22 00:00:00.000	10000.0000
2	2001-03-24 00:00:00.000	1500.0000
3	2001-09-13 00:00:00.000	11500.0000

/* Outcome_o
point		date			out
1	2001-03-14 00:00:00.000	15348.0000
1	2001-03-24 00:00:00.000	3663.0000
1	2001-03-26 00:00:00.000	1221.0000
1	2001-03-28 00:00:00.000	2075.0000
1	2001-03-29 00:00:00.000	2004.0000
1	2001-04-11 00:00:00.000	3195.0400
1	2001-04-13 00:00:00.000	4490.0000
1	2001-04-27 00:00:00.000	3110.0000
1	2001-05-11 00:00:00.000	2530.0000
2	2001-03-22 00:00:00.000	1440.0000
2	2001-03-29 00:00:00.000	7848.0000
2	2001-04-02 00:00:00.000	2040.0000
3	2001-09-13 00:00:00.000	1500.0000
3	2001-09-14 00:00:00.000	2300.0000
3	2002-09-16 00:00:00.000	2150.0000
3	2001-10-02 00:00:00.000	18000.0000

/* Income
code point		date			inc
1	1	2001-03-22 00:00:00.000	15000.0000
10	1	2001-04-13 00:00:00.000	5000.0000
11	1	2001-03-24 00:00:00.000	3400.0000
12	3	2001-09-13 00:00:00.000	1350.0000
13	3	2001-09-13 00:00:00.000	1750.0000
2	1	2001-03-23 00:00:00.000	15000.0000
3	1	2001-03-24 00:00:00.000	3600.0000
4	2	2001-03-22 00:00:00.000	10000.0000
5	2	2001-03-24 00:00:00.000	1500.0000
6	1	2001-04-13 00:00:00.000	5000.0000
7	1	2001-05-11 00:00:00.000	4500.0000
8	1	2001-03-22 00:00:00.000	15000.0000
9	2	2001-03-24 00:00:00.000	1500.0000

/* Outcome
code point		date			out
1	1	2001-03-14 00:00:00.000	15348.0000
10	2	2001-03-22 00:00:00.000	1440.0000
11	2	2001-03-29 00:00:00.000	7848.0000
12	2	2001-04-02 00:00:00.000	2040.0000
13	1	2001-03-24 00:00:00.000	3500.0000
14	2	2001-03-22 00:00:00.000	1440.0000
15	1	2001-03-29 00:00:00.000	2006.0000
16	3	2001-09-13 00:00:00.000	1200.0000
17	3	2001-09-13 00:00:00.000	1500.0000
18	3	2001-09-14 00:00:00.000	1150.0000
2	1	2001-03-24 00:00:00.000	3663.0000
3	1	2001-03-26 00:00:00.000	1221.0000
4	1	2001-03-28 00:00:00.000	2075.0000
5	1	2001-03-29 00:00:00.000	2004.0000
6	1	2001-04-11 00:00:00.000	3195.0400
7	1	2001-04-13 00:00:00.000	4490.0000
8	1	2001-04-27 00:00:00.000	3110.0000
9	1	2001-05-11 00:00:00.000	2530.0000
