drop table if exists MV;

create table MV (CustomerID int, Title varchar(35), Date date); 

insert into MV values ('100', 'B','2000-02-02');
insert into MV values ('100', 'A','2000-03-01');
insert into MV values ('100', 'D','2000-01-01');
insert into MV values ('110', 'B','2000-01-15');
insert into MV values ('110', 'A','2000-01-01');
insert into MV values ('110', 'A','2000-02-01');
insert into MV values ('110', 'C','2000-04-05');
insert into MV values ('123', 'A','2000-05-11');
insert into MV values ('123', 'D','2000-03-03');
insert into MV values ('123', 'B','2000-04-01');
insert into MV values ('123', 'C','2000-06-20');
insert into MV values ('456', 'A','2000-02-11');
insert into MV values ('456', 'D','2000-02-10');



/*CustomerID   TITLE     DATE

用户  电影名称  观看日期

第一题：
找出同时在一月和二月都看过电影的CostumerID

第二题： 
找出每个用户第一次看的电影中最受欢迎的那个
*/

select distinct m1.CustomerID from MV m1, MV m2
where m1.CustomerID = m2.CustomerID
and month(m1.DATE) = '01'
and month(m2.DATE) = '02';

/* Wrong: this only find the most popular movie */
select Title from MV
group by Title
order by count(distinct(customerID)) desc
limit 1

/* Correct */

select Title
from MV
where (CustomerID, Date) in (select CustomerID, min(Date) from MV group by CustomerID )


