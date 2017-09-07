/* find Language having the nth highest Users */
with G as
( select Name, Users, row_number() over(order by Users desc) as 'RowNum'
  from Language
)
select Name
from G
where RowNum <=3
order by Users

/* Second Highest Salary 
Using max() will return a NULL if the value doesn't exist. 
if the second highest value is guaranteed to exist, using LIMIT 1,1 will be the best answer.
*/
select max(salary) as SecondHighestSalary
from Employee
where salary < (select max(salary) from Employee)

/* Change the number after 'offset' gives u n-th highest salary */
select (
  select distinct Salary 
  from Employee 
  order by Salary Desc 
  limit 1 offset 1
)as second

/* find the GPA ranking */
select s1.sID, s1.sName, s1.GPA, count(s2.GPA) as GPA_Rank
from student s1, student s2
where s1.GPA < s2.GPA or (s1.GPA=s2.GPA and s1.sID=s2.sID)
group by s1.sID, s1.GPA
order by s1.GPA desc, s1.sID;

select *
from student 
group by sID
order by GPA desc, sID;


/* find the nth highest GPA from the table */

SELECT *         /*This is the outer query part */
FROM Student s1
WHERE (N-1) = ( /* Subquery starts here */
SELECT COUNT(DISTINCT(s2.GPA))
FROM Student s2
WHERE s2.GPA > s1.GPA)


select *
from(
select s1.sID, s1.sName, s1.GPA, count(s1.GPA) as GPA_Rank
from student s1, student s2
where s1.GPA < s2.GPA or (s1.GPA=s2.GPA and s1.sID=s2.sID)
group by s1.sID, s1.GPA
order by s1.GPA desc, s1.sID) G
order by GPA desc
limit 3,1;

SELECT * FROM table ORDER BY ID LIMIT n-1,1
/* It says return one record starting at record n.

With two arguments, the first argument specifies 
the offset of the first row to return, 
and the second specifies the maximum number of rows to return. 
The offset of the initial row is 0 (not 1):
*/
SELECT * FROM tbl LIMIT 5,10; /* Retrieve rows 6-15 */



/* Query the list of CITY names from STATION which have vowels 
(i.e., a, e, i, o, and u) as both their first and last characters.  */
select distinct city from station
where city REGEXP '^[aeiou].*[aeiou]$';


/* Query the list of CITY names from STATION that do not start with vowels. */
select distinct city from station
where city not REGEXP '^[aeiou]';


select distinct city from station
where city not REGEXP '^[aeiou]' or city not REGEXP '[aeiou]$';

/* Query the list of CITY names from STATION that do not start with vowels and do not end with vowels.*/
select distinct city from station
where city not REGEXP '^[aeiou]' and city not REGEXP '[aeiou]$';

/* where city not REGEXP '^[aeiou].*[aeiou]$';  is wrong */


/* A median is defined as a number separating the higher half of a data set 
from the lower half. Query the median of the Northern Latitudes (LAT_N) 
from STATION and round your answer to  decimal places. */
select round(x.LAT_N,4)
from station x, station y
group by x.LAT_N
having sum(sign(1-sign(y.LAT_N - x.LAT_N))) = (count(*)+1)/2


/**********                    Leetcode SQL             ********************************/
/* 607. Sales Person
Description

Given three tables: salesperson, company, orders.
Output all the names in the table salesperson, who didn’t have sales to company 'RED'.

Example
Input

Table: salesperson

+----------+------+--------+-----------------+-----------+
| sales_id | name | salary | commission_rate | hire_date |
+----------+------+--------+-----------------+-----------+
|   1      | John | 100000 |     6           | 4/1/2006  |
|   2      | Amy  | 120000 |     5           | 5/1/2010  |
|   3      | Mark | 65000  |     12          | 12/25/2008|
|   4      | Pam  | 25000  |     25          | 1/1/2005  |
|   5      | Alex | 50000  |     10          | 2/3/2007  |
+----------+------+--------+-----------------+-----------+
The table salesperson holds the salesperson information. Every salesperson has a sales_id and a name.
Table: company

+---------+--------+------------+
| com_id  |  name  |    city    |
+---------+--------+------------+
|   1     |  RED   |   Boston   |
|   2     | ORANGE |   New York |
|   3     | YELLOW |   Boston   |
|   4     | GREEN  |   Austin   |
+---------+--------+------------+
The table company holds the company information. Every company has a com_id and a name.
Table: orders

+----------+----------+---------+----------+--------+
| order_id |  date    | com_id  | sales_id | amount |
+----------+----------+---------+----------+--------+
| 1        | 1/1/2014 |    3    |    4     | 100000 |
| 2        | 2/1/2014 |    4    |    5     | 5000   |
| 3        | 3/1/2014 |    1    |    1     | 50000  |
| 4        | 4/1/2014 |    1    |    4     | 25000  |
+----------+----------+---------+----------+--------+
The table orders holds the sales record information, salesperson and customer company are represented by sales_id and com_id.
output

+------+
| name | 
+------+
| Amy  | 
| Mark | 
| Alex |
+------+
.
*/

select name 
from salesperson s 
where s.sales_id not in 
(select sales_id from 
 orders o join company c on c.com_id = o.com_id
 where c.name = 'RED'
)

/* 627. Swap Salary
Given a table salary, such as the one below, that has m=male and f=female values. 
Swap all f and m values (i.e., change all f values to m and vice versa) with a single update query and no intermediate temp table.

For example:
| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
After running your query, the above salary table should have the following rows:
| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |
*/

update salary
set sex = (case when sex = 'f' then 'm'
                when sex = 'm' then 'f'
          end)



/* 612. Shortest Distance in a Plane
Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.

Write a query to find the shortest distance between these points rounded to 2 decimals.
| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
| shortest |
|----------|
| 1.00     |
Note: The longest distance among all the points are less than 10000.
*/

select cast(min(distance) as decimal(5,2)) as shortest
from
(select sqrt(power((p1.x-p2.x), 2)+power((p1.y-p2.y),2)) as distance
from point_2d p1, point_2d p2
where concat(p1.x, p1.y) <> concat(p2.x, p2.y)
) t

SELECT
    ROUND(SQRT(MIN((POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)))), 2) AS shortest
FROM
    point_2d p1
        JOIN
    point_2d p2 ON p1.x != p2.x OR p1.y != p2.y;


/* 181. 	Employees Earning More Than Their Managers   
The Employee table holds all employees including their managers. 
Every employee has an Id, and there is also a column for the manager Id.
+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than 
their managers. For the above table, Joe is the only employee who earns more than his manager.
+----------+
| Employee |
+----------+
| Joe      |
+----------+
*/
select E1.Name as Employee
from Employee E1 join Employee E2
on E1.ManagerId = E2.Id
where E1.Salary > E2. Salary

/* 183. Customers Who Never Order
Suppose that a website contains two tables, the Customers table and the Orders table. 
Write a SQL query to find all customers who never order anything.

Table: Customers.
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Using the above tables as example, return the following:
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
*/
select Name as Customers
from Customers
where Customers.Id not in (select CustomerId from Orders)

/* 197. Rising Temperature
Given a Weather table, write a SQL query to find all dates' Ids with higher temperature 
compared to its previous (yesterday's) dates.
+---------+------------+------------------+
| Id(INT) | Date(DATE) | Temperature(INT) |
+---------+------------+------------------+
|       1 | 2015-01-01 |               10 |
|       2 | 2015-01-02 |               25 |
|       3 | 2015-01-03 |               20 |
|       4 | 2015-01-04 |               30 |
+---------+------------+------------------+
For example, return the following Ids for the above Weather table:
+----+
| Id |
+----+
|  2 |
|  4 |
+----+
*/
SELECT t1.Id
FROM Weather t1
INNER JOIN Weather t2
ON TO_DAYS(t1.Date) = TO_DAYS(t2.Date) + 1
WHERE t1.Temperature > t2.Temperature;

select W1.Id
from Weather W1, Weather W2
where to_days(W1.Date) - to_days(W2.Date) = 1 and W1.Temperature > W2.Temperature;

/* 196. Delete Duplicate Emails
Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
*/

delete p1
from Person p1, Person p2
where p1.Id > p2.Id and p1.Email = p2.Email

/* 596. Classes More Than 5 Students
There is a table courses with columns: student and class

Please list out all classes which have more than or equal to 5 students.

For example, the table:

+---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+
Should output:

+---------+
| class   |
+---------+
| Math    |
+---------+
*/
select class 
from courses
group by class
having count(distinct student) >= 5; /* Cannot use count(class). Use count(distinct student) because student is not Primary key */

/* 178. Rank Scores
Write a SQL query to rank scores. 
If there is a tie between two scores, both should have the same ranking. 
Note that after a tie, the next ranking number should be the next consecutive integer value. 
In other words, there should be no "holes" between ranks.
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
*/

select s.score, count(distinct t.score) as Rank
from Scores s, Scores t
where s.score <= t.score
group by s.Id  /* This step is important */
order by Rank 

/* Always Count, Pre-uniqued: 
Same as the previous one, but faster because it has a subquery that "uniquifies" the scores first. 
Not entirely sure why it's faster, probably MySQL makes tmp a temporary table and uses it for every outer Score.*/

SELECT
  Score,
  (SELECT count(*) FROM (SELECT distinct Score t FROM Scores) tmp WHERE t >= Score) Rank
FROM Scores
ORDER BY Score desc

/* Change ranking: after a tie, the next ranking number should skip the consecutive integer value. 
+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 3    |
| 3.65  | 4    |
| 3.65  | 4    |
| 3.50  | 6    |
+-------+------+
*/
select s.score, count(t.score) as Rank
from Scores s, Scores t
where s.score < t.score or (s.score=t.score and s.Id=t.Id)
group by s.Id
order by Rank 


/* 180. Consecutive Numbers
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
*/

select distinct l1.Num as ConsecutiveNums 
from Logs l1, Logs l2, Logs l3
where l1.Id = L2.Id-1 and l2.Id=l3.Id-1
and l1.Num=l2.Num and l2.Num=l3.Num


/* 184. Department Highest Salary
The Employee table holds all employees. Every employee has an Id, a salary, 
and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. 
For the above tables, Max has the highest salary in the IT department and Henry has the 
highest salary in the Sales department.
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
*/

/* Wrong answer: Did not consider the case when there are more than 1 person having the highest salary in the same department*/
select *
from (
select Department.Name as Department, Employee.Name as Employee, Salary
from Department, Employee
where DepartmentId = Department.Id
order by Department.Name, Salary Desc) tmp
group by tmp.Department

/* Correct Answers */
select D.Name as Department, E.Name as Employee, Salary
from Department D, Employee E
where E.DepartmentId = D.Id
and (E.DepartmentId ,Salary) in (select DepartmentId, max(Salary) as Salary from Employee group by DepartmentId)

/* faster than previous, maybe due to temp table */
SELECT D.Name AS Department ,E.Name AS Employee ,E.Salary 
FROM
	Employee E,
	(SELECT DepartmentId,max(Salary) as Salary FROM Employee GROUP BY DepartmentId) T,
	Department D
WHERE E.DepartmentId = T.DepartmentId 
  AND E.Salary = T.Salary
  AND E.DepartmentId = D.id
  
/* 177. Nth Highest Salary
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the nth highest salary where n = 2 is 200. 
If there is no nth highest salary, then the query should return null.

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
*/
/* MySQL does not accept LIMIT (N-1) but only LIMIT N */
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
declare M INT;
SET M=N-1;
  RETURN (
      select distinct Salary 
      from Employee
      order by Salary desc
      limit M, 1
  );
END

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N=N-1;
  RETURN (
      select distinct Salary 
      from Employee
      order by Salary desc
      limit M, 1
  );
END

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (      
      select distinct Salary 
      from Employee e1
      where (N-1) = (select count(distinct Salary) from Employee e2 where e1.Salary < e2.Salary)
  );
END


/* 601. Human Traffic of Stadium
X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, date, people

Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

For example, the table stadium:
+------+------------+-----------+
| id   | date       | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
For the sample data above, the output is:

+------+------------+-----------+
| id   | date       | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
Note:
Each day only have one row record, and the dates are increasing with id increasing.
*/
select distinct s1.id, s1.date, s1.people
from stadium s1, stadium s2, stadium s3
where ((s2.id-s1.id = 1 and s3.id-s2.id = 1)
or (s2.id-s1.id = -1 and s3.id-s1.id = 1)
or (s2.id-s1.id = -1 and s3.id-s2.id = -1))
and s1.people >=100 and s2.people >=100 and s3.people >=100
order by s1.id

/* 185. Department Top Three Salaries
The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
*/
/* No more than 2 higher salary can be found in the department. 
Also covers the situation by distinct when more than one person have the same salary.*/
select D.Name as Department, E.Name as Employee, Salary
from Department D, Employee E
where D.Id = E.DepartmentId
and (select count(distinct Salary) from Employee where DepartmentId=D.Id and Salary>E.Salary)<3
order by D.Name, Salary desc

/* Extension: change N to generalize the question to find Department Top N Salaries */
select D.Name as Department, E.Name as Employee, Salary
from Department D, Employee E
where D.Id = E.DepartmentId
and N > (select count(distinct Salary) from Employee where DepartmentId=D.Id and Salary>E.Salary)
order by D.Name, Salary desc

/* find the Nth highest salary: 数一下哪个salary比(N-1)个distinct salary 小 */
select *
from Employee E
where (N-1) = (select count(distinct Salary) from Employee where E.Salary<Salary)

SELECT salary FROM Employee ORDER BY salary DESC LIMIT N-1, 1 


/* find the top N salaries */
select *
from Employee E
where N > (select count(distinct Salary) from Employee where E.Salary<Salary)

/* find the bottom N salaries */
select *
from Employee E
where N > (select count(distinct Salary) from Employee where Salary < E.Salary)


/* 613. Shortest Distance in a Line 
able point holds the x coordinate of some points on x-axis in a plane, which are all integers.

Write a query to find the shortest distance between two points in these points.
| x   |
|-----|
| -1  |
| 0   |
| 2   |
The shortest distance is '1' obviously, which is from point '-1' to '0'. So the output is as below:
| shortest|
|---------|
| 1       |
Note: Every point is unique, which means there is no duplicates in table point.

Follow-up: What if all these points have an id and are arranged from the left most to the right most of x axis?
*/

select min(p1.x - p2.x) as shortest
from point p1, point p2
where p1.x-p2.x>0  /* no need to add p1.x != p2.x */


/* 570. Managers with at Least 5 Direct Reports
The Employee table holds all employees including their managers. 
Every employee has an Id, and there is also a column for the manager Id.

+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+
Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. 
For the above table, your SQL query should return:

+-------+
| Name  |
+-------+
| John  |
+-------+
Note: No one would report to himself.
*/
select e1.Name 
from Employee e1
inner join Employee e2 on e1.Id = e2.ManagerId
group by e1.Name
having count(e1.Name) >=5

/* 574. Winning Candidate
Table: Candidate
+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  
Table: Vote
+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
id is the auto-increment primary key, CandidateId is the id appeared in Candidate table.

Write a sql to find the name of the winning candidate, the above example will return the winner B.
+------+
| Name |
+------+
| B    |
+------+
Notes: You may assume there is no tie, in other words there will be at most one winning candidate.
*/
/* Bug: 1) Only one candidate and it does not have max votes  2) Table Vote is empty 3) Table Candidate is empty */
select Name
from Candidate
join Vote on Vote.CandidateId = Candidate.Id
group by Name 
order by count(Name) desc
limit 1

/* Correct */
select Name
from Candidate
where id = (select CandidateId from Vote 
            group by CandidateId order by count(CandidateId) desc 
            limit 1)
            
/* if use 'where id in', when there is no match, sql will return '[null]' instead of '[]' */   

/* 597. Friend Requests I: Overall Acceptance Rate
In social network like Facebook or Twitter, people send friend requests 
and accept others’ requests as well. Now given two tables as below:

Table: friend_request
| sender_id | send_to_id |request_date|
|-----------|------------|------------|
| 1         | 2          | 2016_06-01 |
| 1         | 3          | 2016_06-01 |
| 1         | 4          | 2016_06-01 |
| 2         | 3          | 2016_06-02 |
| 3         | 4          | 2016-06-09 |
Table: request_accepted
| requester_id | accepter_id |accept_date |
|--------------|-------------|------------|
| 1            | 2           | 2016_06-03 |
| 1            | 3           | 2016-06-08 |
| 2            | 3           | 2016-06-08 |
| 3            | 4           | 2016-06-09 |
| 3            | 4           | 2016-06-10 |
Write a query to find the overall acceptance rate of requests rounded to 2 decimals, 
which is the number of acceptance divide the number of requests.

For the sample data above, your query should return the following result.
|accept_rate|
|-----------|
|       0.80|

Note:
The accepted requests are not necessarily from the table friend_request. 
In this case, you just need to simply count the total accepted requests 
(no matter whether they are in the original requests), 
and divide it by the number of requests to get the acceptance rate.

It is possible that a sender sends multiple requests to the same receiver, 
and a request could be accepted more than once.
In this case, the ‘duplicated’ requests or acceptances are only counted once.
If there is no requests at all, you should return 0.00 as the accept_rate.

Explanation: There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80.

Follow-up:
Can you write a query to return the accept rate but for every month?
How about the cumulative accept rate for every day?
*/        
 
select case when count(distinct sender_id, send_to_id) = 0 then 0.00
            else round(count(distinct requester_id,accepter_id)/count(distinct sender_id, send_to_id), 2) end as accept_rate
from friend_request f, request_accepted r

/* other solution */
select if( f.ct = 0, 0.00, cast(r.ct/f.ct as decimal(4,2) ) ) as accept_rate
from
(select count(distinct sender_id, send_to_id) as ct
from friend_request) as f
join
(select count(distinct requester_id, accepter_id) as ct
from request_accepted) as r

/* Follow-up:
Can you write a query to return the accept rate but for every month?
How about the cumulative accept rate for every day?
*/     

/* 602. Friend Requests II: Who Has the Most Friends   
In social network like Facebook or Twitter, people send friend requests and accept others' requests as well.

Table request_accepted holds the data of friend acceptance, while requester_id and accepter_id both are the id of a person.
| requester_id | accepter_id | accept_date|
|--------------|-------------|------------|
| 1            | 2           | 2016_06-03 |
| 1            | 3           | 2016-06-08 |
| 2            | 3           | 2016-06-08 |
| 3            | 4           | 2016-06-09 |
Write a query to find the the people who has most friends and the most friends number. For the sample data above, the result is:
| id | num |
|----|-----|
| 3  | 3   |
Note:
It is guaranteed there is only 1 people having the most friends.
The friend request could only been accepted once, which mean there is no multiple records with the same requester_id and accepter_id value.
Explanation:
The person with id '3' is a friend of people '1', '2' and '4', so he has 3 friends in total, which is the most number than any others.
Follow-up:
In the real world, multiple people could have the same most number of friends, can you find all these people in this case?
*/

select id, sum(n) as num
from
((select requester_id as id, count(requester_id) as n
from request_accepted
group by requester_id)
union all
(select accepter_id as id, count(accepter_id) as n
from request_accepted
group by accepter_id)) t
group by id
order by num desc
limit 1

select id, count(*) as num
from
(select requester_id as id, accepter_id as a
from request_accepted
union all
select accepter_id as id, requester_id as a
from request_accepted) t
group by id
order by num desc
limit 1

/* 619. Biggest Single Number
Table number contains many numbers in column num including duplicated ones.
Can you write a SQL query to find the biggest number, which only appears once.
+---+
|num|
+---+
| 8 |
| 8 |
| 3 |
| 3 |
| 1 |
| 4 |
| 5 |
| 6 | 
For the sample data above, your query should return the following result:
+---+
|num|
+---+
| 6 |
Note:
If there is no such number, just output null.
 */
select max(num) as num
from
(select num
from number
group by num
having count(num) = 1) tmp


/*585. Investments in 2016
Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria:

Have the same TIV_2015 value as one or more other policyholders.
Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique).
Input Format:
The insurance table is described as follows:

| Column Name | Type          |
|-------------|---------------|
| PID         | INTEGER(11)   |
| TIV_2015    | NUMERIC(15,2) |
| TIV_2016    | NUMERIC(15,2) |
| LAT         | NUMERIC(5,2)  |
| LON         | NUMERIC(5,2)  |
where PID is the policyholder's policy ID, TIV_2015 is the total investment value in 2015, TIV_2016 is the total investment value in 2016, LAT is the latitude of the policy holder's city, and LON is the longitude of the policy holder's city.

Sample Input

| PID | TIV_2015 | TIV_2016 | LAT | LON |
|-----|----------|----------|-----|-----|
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |
Sample Output

| TIV_2016 |
|----------|
| 45.00    |

*/ 

select round(sum(TIV_2016), 2) as TIV_2016
from insurance a
where (select count(*) from insurance b where a.LAT=b.LAT and a.LON=b.LON) = 1
and (select count(*) from insurance c where a.TIV_2015=c.TIV_2015) > 1


SELECT SUM(insurance.TIV_2016) AS TIV_2016
FROM insurance
WHERE insurance.TIV_2015 IN -- meet the creteria #1
    (
       SELECT TIV_2015
        FROM insurance
        GROUP BY TIV_2015
        HAVING COUNT(*) > 1
        )
AND CONCAT(LAT, LON) IN -- meet the creteria #2
    (
      SELECT CONCAT(LAT, LON) -- trick to take the LAT and LON as a pair
      FROM insurance
      GROUP BY LAT , LON
      HAVING COUNT(*) = 1
)




/* */
update salary set sex = case when sex = 'm' then 'f' else 'm' end;


/*
An Explain Plan would have shown you why exactly you should use Exists. 
Usually the question comes Exists vs Count(*).  Exists is faster. Why?

With regard to challenges present by NULL: 
when subquery returns Null, for IN the entire query becomes Null. So you need to handle that as well. 
But using Exist, it's merely a false. Much easier to cope. 
Simply IN can't compare anything with Null but Exists can.
e.g. Exists (Select * from yourtable where bla = 'blabla'); you get true/false the moment one hit is found/matched.
In this case IN sort of takes the position of the Count(*) to select ALL matching rows based on the WHERE because it's comparing all values.

But don't forget this either:
EXISTS executes at high speed against IN : when the subquery results is very large.
IN gets ahead of EXISTS : when the subquery results is very small.
*/



/* 586. Customer Placing the Largest Number of Orders
Query the customer_number from the orders table for the customer who has placed the largest number of orders.

It is guaranteed that exactly one customer will have placed more orders than any other customer.

The orders table is defined as follows:

| Column            | Type      |
|-------------------|-----------|
| order_number (PK) | int       |
| customer_number   | int       |
| order_date        | date      |
| required_date     | date      |
| shipped_date      | date      |
| status            | char(15)  |
| comment           | char(200) |
Sample Input

| order_number | customer_number | order_date | required_date | shipped_date | status | comment |
|--------------|-----------------|------------|---------------|--------------|--------|---------|
| 1            | 1               | 2017-04-09 | 2017-04-13    | 2017-04-12   | Closed |         |
| 2            | 2               | 2017-04-15 | 2017-04-20    | 2017-04-18   | Closed |         |
| 3            | 3               | 2017-04-16 | 2017-04-25    | 2017-04-20   | Closed |         |
| 4            | 3               | 2017-04-18 | 2017-04-28    | 2017-04-25   | Closed |         |
Sample Output

| customer_number |
|-----------------|
| 3               |
Explanation

The customer with number '3' has two orders, which is greater than either customer '1' or '2' 
because each of them  only has one order. So the result is customer_number '3'.

Follow up: What if more than one customer have the largest number of orders, can you find 
all the customer_number in this case?
*/

select customer_number 
from (select customer_number, count(order_number) 
      from orders 
      group by customer_number
      order by count(order_number) desc
      limit 1) tmp
      
/* slower request */
select customer_number
from orders 
group by customer_number
order by count(customer_number) desc
limit 1;

/* follow up */      
select customer_number
from orders 
group by customer_number
having count(customer_number) = (select count(customer_number) 
                                 from orders 
                                 group by customer_number
                                 order by count(customer_number) desc
                                 limit 1)
                                 
/* 580. Count Student Number in Departments
2 data tables, student and department.

Write a query to print the respective department name and number of students majoring in each department 
for all departments in the department table (even ones with no current students).

Sort your results by descending number of students, then alphabetically by department name.

The student table:

| Column Name  | Type      |
|--------------|-----------|
| student_id   | Integer   |
| student_name | String    |
| gender       | Character |
| dept_id      | Integer   |
where dept_id is the department ID associated with their declared major.

the department table:

| Column Name | Type    |
|-------------|---------|
| dept_id     | Integer |
| dept_name   | String  |
where dept_id is the department's ID number and dept_name is the department name.

Here is an example input:
student table:

| student_id | student_name | gender | dept_id |
|------------|--------------|--------|---------|
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
department table:
| dept_id | dept_name   |
|---------|-------------|
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |

The Output should be:
| dept_name   | student_number |
|-------------|----------------|
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |

*/          
/* note: left join and group by department.dept_id  */                            
select dept_name, count(student_name) as student_number
from department d left join student s
on d.dept_id = s.dept_id
group by d.dept_id
order by student_number desc, dept_name


/* 569. Median Employee Salary
The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|1    | A          | 2341   |
|2    | A          | 341    |
|3    | A          | 15     |
|4    | A          | 15314  |
|5    | A          | 451    |
|6    | A          | 513    |
|7    | B          | 15     |
|8    | B          | 13     |
|9    | B          | 1154   |
|10   | B          | 1345   |
|11   | B          | 1221   |
|12   | B          | 234    |
|13   | C          | 2345   |
|14   | C          | 2645   |
|15   | C          | 2645   |
|16   | C          | 2652   |
|17   | C          | 65     |
+-----+------------+--------+
Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|5    | A          | 451    |
|6    | A          | 513    |
|12   | B          | 234    |
|9    | B          | 1154   |
|14   | C          | 2645   |
+-----+------------+--------+
*/
select x.id, x.company, x.salary
from Employee x, Employee y
where x.company = y.company
group by x.company, x.salary
having sum(sign(1-sign(x.salary - y.salary))) = floor((count(*)+1)/2) 
or sum(sign(1-sign(x.salary - y.salary))) = ceil((count(*)+1)/2) 


/* 614. Second Degree Follower
In facebook, there is a follow table with two columns: followee, follower.

Please write a sql query to get the amount of each follower’s follower if he/she has one.

For example:

+-------------+------------+
| followee    | follower   |
+-------------+------------+
|     A       |     B      |
|     B       |     C      |
|     B       |     D      |
|     D       |     E      |
+-------------+------------+
should output:
+-------------+------------+
| follower    | num        |
+-------------+------------+
|     B       |  2         |
|     D       |  1         |
+-------------+------------+
Explaination:
Both B and D exist in the follower list, when as a followee, B's follower is C and D, and D's follower is E. A does not exist in follower list.
Note:
Followee would not follow himself/herself in all cases.
Please display the result in follower's alphabet order.
*/
select x.follower, count(distinct y.follower) as num
from follow x join follow y
on x.follower = y.followee
group by x.follower
order by x.follower

/* did not pass when there was duplicates*/
select y.followee as follower, count(y.follower) as num
from follow x join follow y
on x.follower = y.followee
group by y.followee
order by y.followee


/* did not pass  */
select y.followee as follower, count(distinct y.follower) as num
from follow x join follow y
on x.follower = y.followee
group by y.followee
order by y.followee

/* 615. Average Salary: Departments VS Company
Given two tables as below, write a query to display the comparison result (higher/lower/same) 
of the average salary of employees in a department to the company's average salary.

Table: salary
| id | employee_id | amount | pay_date   |
|----|-------------|--------|------------|
| 1  | 1           | 9000   | 2017-03-31 |
| 2  | 2           | 6000   | 2017-03-31 |
| 3  | 3           | 10000  | 2017-03-31 |
| 4  | 1           | 7000   | 2017-02-28 |
| 5  | 2           | 6000   | 2017-02-28 |
| 6  | 3           | 8000   | 2017-02-28 |
The employee_id column refers to the employee_id in the following table employee.
| employee_id | department_id |
|-------------|---------------|
| 1           | 1             |
| 2           | 2             |
| 3           | 2             |
So for the sample data above, the result is:
| pay_month | department_id | comparison  |
|-----------|---------------|-------------|
| 2017-03   | 1             | higher      |
| 2017-03   | 2             | lower       |
| 2017-02   | 1             | same        |
| 2017-02   | 2             | same        |
Explanation
In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.
With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.
*/
/* Need to consider when pay_date is on different days */
/* if not use 'round', it's wrong, why? */
select left(s.pay_date, 7) as pay_month, department_id, 
case when round(avg(amount),3) > ac then 'higher'
     when round(avg(amount),3) < ac then 'lower'
     else 'same' end as comparison 
from salary s, employee e,

(select left(pay_date, 7) as pay_m, round(avg(amount),3) as ac
from salary s, employee e
where s.employee_id = e.employee_id
group by pay_m) tmp

where s.employee_id = e.employee_id and tmp.pay_m = left(s.pay_date, 7)
group by pay_month, department_id
order by department_id, pay_month;

/* Solve this problem by 3 steps: 1. Calculate the company's average salary in every month 2. Calculate the each department's average salary in every month 3. Compare the previous numbers and display the result*/
select department_salary.pay_month, department_id,
case
  when department_avg>company_avg then 'higher'
  when department_avg<company_avg then 'lower'
  else 'same'
end as comparison
from
(
  select department_id, avg(amount) as department_avg, date_format(pay_date, '%Y-%m') as pay_month
  from salary join employee on salary.employee_id = employee.employee_id
  group by department_id, pay_month
) as department_salary
join
(
  select avg(amount) as company_avg,  date_format(pay_date, '%Y-%m') as pay_month from salary group by date_format(pay_date, '%Y-%m')
) as company_salary
on department_salary.pay_month = company_salary.pay_month
;

/* 579. Find Cumulative Salary of an Employee
The Employee table holds the salary information in a year.

Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.

The result should be displayed by 'Id' ascending, and then by 'Month' descending.

Example
Input

| Id | Month | Salary |
|----|-------|--------|
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |
Output

| Id | Month | Salary |
|----|-------|--------|
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
Explanation
Employee '1' has 3 salary records for the following 3 months except the most recent month '4': salary 40 for month '3', 30 for month '2' and 20 for month '1'
So the cumulative sum of salary of this employee over 3 months is 90(40+30+20), 50(30+20) and 20 respectively.

| Id | Month | Salary |
|----|-------|--------|
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |

Employee '2' only has one salary record (month '1') except its most recent month '2'.
| Id | Month | Salary |
|----|-------|--------|
| 2  | 1     | 20     |

Employ '3' has two salary records except its most recent pay month '4': month '3' with 60 and month '2' with 40. So the cumulative salary is as following.
| Id | Month | Salary |
|----|-------|--------|
| 3  | 3     | 100    |
| 3  | 2     | 40     |

*/


/** 618. Students Report By Geography
A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.

| name   | continent |
|--------|-----------|
| Jack   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jane   | America   |
Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
For the sample input, the output is:
| America | Asia | Europe |
|---------|------|--------|
| Jack    | Xi   | Pascal |
| Jane    |      |        |

Follow-up: If it is unknown which continent has the most students, can you write a query to generate the student report?
*/

select
   min(America) as America, min(Asia) as Asia, min(Europe) as Europe
from
    (select
     case when continent='America' then @a:=@a+1
          when continent='Asia' then @b:=@b+1
          when continent='Europe' then @c:=@c+1 end as row,
     case when continent='America' then name end as America,
     case when continent='Asia' then name end as Asia,
     case when continent='Europe' then name end as Europe
     from student join (select @a:=0, @b:=0, @c:=0) as r
     order by name) o
group by row;


set @r1 = 0, @r2 = 0, @r3 = 0;
select min(America) America, min(Asia) Asia, min(Europe) Europe
from (select case when continent='America' then @r1 :=@r1+1
                  when continent='Asia' then @r2 :=@r2+1
                  when continent='Europe' then @r3 :=@r3+1 end RowNum,
             case when continent='America' then name end America,
             case when continent='Asia' then name end Asia,
             case when continent='Europe' then name end Europe
      from student
      order by name) T
group by RowNum

/* other solution */
SELECT 
    America, Asia, Europe
FROM
    (SELECT @as:=0, @am:=0, @eu:=0) t,
    (SELECT 
        @as:=@as + 1 AS asid, name AS Asia
    FROM
        student
    WHERE
        continent = 'Asia'
    ORDER BY Asia) AS t1
        RIGHT JOIN
    (SELECT 
        @am:=@am + 1 AS amid, name AS America
    FROM
        student
    WHERE
        continent = 'America'
    ORDER BY America) AS t2 ON asid = amid
        LEFT JOIN
    (SELECT 
        @eu:=@eu + 1 AS euid, name AS Europe
    FROM
        student
    WHERE
        continent = 'Europe'
    ORDER BY Europe) AS t3 ON amid = euid
;
/* check the output, find the difference*/
select
case when continent='America' then name end as America,
case when continent='Asia' then name end as Asia,
case when continent='Europe' then name end as Europe
from student
/* check this */
SELECT continent,GROUP_CONCAT(name) 
FROM student 
GROUP BY continent; 

/*** 262. Trips and Users
The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+
The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+
Write a SQL query to find the cancellation rate of requests made by unbanned clients between Oct 1, 2013 and Oct 3, 2013. For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+
*/

select Request_at as Day, round (sum(case when Status = 'completed' then 0
     else 1 end)/count(Client_Id), 2) as 'Cancellation Rate'
from Trips T
where Request_at >= '2013-10-01' and Request_at <= '2013-10-03'
and Client_Id not in (select Users_Id as Client_Id from Users where Banned = 'Yes')
group by Request_at