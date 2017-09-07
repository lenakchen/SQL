create database painting;

drop table if exists utQ;
drop table if exists utV;
drop table if exists utB;

create table utQ (Q_ID int, Q_NAME varchar(35)); 
create table utV (V_ID int, V_NAME varchar(35), V_COLOR char(1));
create table utB (B_Q_ID int, B_V_ID int, B_VOL smallint, B_DATETIME timestamp); /*datatype 'datetime' not exist in psql*/

insert into utB values ();

insert into utV values ();

insert into utQ values ();

/* 
The utQ table contains the identifiers and names of squares, the initial color of which is black. 
The utV table contains the identifiers and names of spray cans and the color of paint they are filled with.
The utB table holds information on squares being spray-painted, and contains the square and spray can identifiers, the quantity of paint being applied, and the time of the painting event.
It should be noted that
- a spray can may contain paint of one of three colors: red (V_COLOR='R'), green (V_COLOR='G'), or blue (V_COLOR='B');
- any spray can initially contains 255 units of paint;
- the square color is defined in accordance with the RGB model, i.e. R=0, G=0, B=0 is black, whereas R=255, G=255, B=255 is white;
- any record in the utB table decreases the paint quantity in the corresponding spray can by B_VOL and accordingly increases the amount of paint applied to the square by the same value;
- B_VOL must be greater than 0 and less or equal to 255;
- the paint quantity of a single color applied to one square can’t exceed 255, and there can’t be a less than zero amount of paint in a spray can;
- the time of the painting event (B_DATETIME) is specified with one second precision, i.e. it does not contain milliseconds;
- for historical reasons, the spray cans are referred to as “balloons” by many of the exercises, and the utV table contains spray can names (V_NAME column) such as “Balloon # 01”, etc.

/* utB
B_DATETIME				B_Q_ID	B_V_ID	B_VOL
2000-01-01 01:13:36.000	22	50	50
2001-01-01 01:13:37.000	22	50	50
2002-01-01 01:13:38.000	22	51	50
2002-06-01 01:13:39.000	22	51	50
2003-01-01 01:12:01.000	1	1	155
2003-01-01 01:12:03.000	2	2	255
2003-01-01 01:12:04.000	3	3	255
2003-01-01 01:12:05.000	1	4	255
2003-01-01 01:12:06.000	2	5	255
2003-01-01 01:12:07.000	3	6	255
2003-01-01 01:12:08.000	1	7	255
2003-01-01 01:12:09.000	2	8	255
2003-01-01 01:12:10.000	3	9	255
2003-01-01 01:12:11.000	4	10	50
2003-01-01 01:12:12.000	5	11	100
2003-01-01 01:12:13.000	5	12	155
2003-01-01 01:12:14.000	5	13	155
2003-01-01 01:12:15.000	5	14	100
2003-01-01 01:12:16.000	5	15	50
2003-01-01 01:12:17.000	5	16	205
2003-01-01 01:12:18.000	6	10	155
2003-01-01 01:12:19.000	6	17	100
2003-01-01 01:12:20.000	6	18	255
2003-01-01 01:12:21.000	6	19	255
2003-01-01 01:12:22.000	7	17	155
2003-01-01 01:12:23.000	7	20	100
2003-01-01 01:12:24.000	7	21	255
2003-01-01 01:12:25.000	7	22	255
2003-01-01 01:12:26.000	8	10	50
2003-01-01 01:12:27.000	9	23	255
2003-01-01 01:12:28.000	9	24	255
2003-01-01 01:12:29.000	9	25	100
2003-01-01 01:12:30.000	9	26	155
2003-01-01 01:12:31.000	10	25	155
2003-01-01 01:12:31.000	10	26	100
2003-01-01 01:12:33.000	10	27	10
2003-01-01 01:12:34.000	10	28	10
2003-01-01 01:12:35.000	10	29	245
2003-01-01 01:12:36.000	10	30	245
2003-01-01 01:12:37.000	11	31	100
2003-01-01 01:12:38.000	11	32	100
2003-01-01 01:12:39.000	11	33	100
2003-01-01 01:12:40.000	11	34	155
2003-01-01 01:12:41.000	11	35	155
2003-01-01 01:12:42.000	11	36	155
2003-01-01 01:12:43.000	12	31	155
2003-01-01 01:12:44.000	12	32	155
2003-01-01 01:12:45.000	12	33	155
2003-01-01 01:12:46.000	12	34	100
2003-01-01 01:12:47.000	12	35	100
2003-01-01 01:12:48.000	12	36	100
2003-01-01 01:13:01.000	4	37	20
2003-01-01 01:13:02.000	8	38	20
2003-01-01 01:13:03.000	13	39	123
2003-01-01 01:13:04.000	14	39	111
2003-01-01 01:13:05.000	14	40	50
2003-01-01 01:13:05.000	4	37	185
2003-01-01 01:13:06.000	15	41	50
2003-01-01 01:13:07.000	15	41	50
2003-01-01 01:13:08.000	15	42	50
2003-01-01 01:13:09.000	15	42	50
2003-01-01 01:13:10.000	16	42	50
2003-01-01 01:13:11.000	16	42	50
2003-01-01 01:13:12.000	16	43	50
2003-01-01 01:13:13.000	16	43	50
2003-01-01 01:13:14.000	16	47	50
2003-01-01 01:13:15.000	17	44	10
2003-01-01 01:13:16.000	17	44	10
2003-01-01 01:13:17.000	17	45	10
2003-01-01 01:13:18.000	17	45	10
2003-01-01 01:13:24.000	19	44	10
2003-01-01 01:13:25.000	19	45	10
2003-01-01 01:13:26.000	19	45	10
2003-02-01 01:13:19.000	18	45	10
2003-02-01 01:13:27.000	20	45	10
2003-02-01 01:13:31.000	21	49	50
2003-02-02 01:13:32.000	21	49	50
2003-02-03 01:13:33.000	21	50	50
2003-02-04 01:13:34.000	21	50	50
2003-02-05 01:13:35.000	21	48	1
2003-03-01 01:13:20.000	18	45	10
2003-03-01 01:13:28.000	20	45	10
2003-04-01 01:13:21.000	18	46	10
2003-04-01 01:13:29.000	20	46	10
2003-05-01 01:13:22.000	18	46	10
2003-05-01 01:13:30.000	20	46	10
2003-06-11 01:13:23.000	19	44	10
2003-06-23 01:12:02.000	1	1	100

utQ
Q_ID	Q_NAME
1	Square # 01
10	Square # 10
11	Square # 11
12	Square # 12
13	Square # 13
14	Square # 14
15	Square # 15
16	Square # 16
17	Square # 17
18	Square # 18
19	Square # 19
2	Square # 02
20	Square # 20
21	Square # 21
22	Square # 22
23	Square # 23
25	Square # 25
3	Square # 03
4	Square # 04
5	Square # 05
6	Square # 06
7	Square # 07
8	Square # 08
9	Square # 09

utV
V_ID	V_NAME	V_COLOR
1	Balloon # 01	R
10	Balloon # 10	R
11	Balloon # 11	R
12	Balloon # 12	R
13	Balloon # 13	G
14	Balloon # 14	G
15	Balloon # 15	B
16	Balloon # 16	B
17	Balloon # 17	R
18	Balloon # 18	G
19	Balloon # 19	B
2	Balloon # 02	R
20	Balloon # 20	R
21	Balloon # 21	G
22	Balloon # 22	B
23	Balloon # 23	R
24	Balloon # 24	G
25	Balloon # 25	B
26	Balloon # 26	B
27	Balloon # 27	R
28	Balloon # 28	G
29	Balloon # 29	R
3	Balloon # 03	R
30	Balloon # 30	G
31	Balloon # 31	R
32	Balloon # 32	G
33	Balloon # 33	B
34	Balloon # 34	R
35	Balloon # 35	G
36	Balloon # 36	B
37	Balloon # 37	R
38	Balloon # 38	G
39	Balloon # 39	B
4	Balloon # 04	G
40	Balloon # 40	R
41	Balloon # 41	R
42	Balloon # 42	G
43	Balloon # 43	B
44	Balloon # 44	R
45	Balloon # 45	G
46	Balloon # 46	B
47	Balloon # 47	B
48	Balloon # 48	G
49	Balloon # 49	R
5	Balloon # 05	G
50	Balloon # 50	G
51	Balloon # 51	B
52	Balloon # 52	R
53	Balloon # 53	G
54	Balloon # 54	B
6	Balloon # 06	G
7	Balloon # 07	B
8	Balloon # 08	B
9	Balloon # 09	B
*/