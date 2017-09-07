
/* two tables: Students and Grades. 
Students： ID, Name, Marks.
Grades: Grade, Min_Mark, Max_Mark.
Generate three columns:  Name, Grade and Mark. Order by grade descending order, name, marks. 
Print "NULL"  as the name if the grade is less than 8.
*/
select case when grade<8 then null else name end as name, 
grade, marks
from Students s inner join Grades g on s.marks between g.min_mark and g.max_mark
order by grade desc, name, marks

/* Example: CASE statement  */
SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 THEN '201-250'
            WHEN weight > 175 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players
  
  SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 AND weight <= 250 THEN '201-250'
            WHEN weight > 175 AND weight <= 200 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players
  
  SELECT player_name,
       CASE WHEN year = 'FR' AND position = 'WR' THEN 'frosh_wr'
            ELSE NULL END AS sample_case_statement
  FROM benn.college_football_players
  
/* Using CASE with aggregate functions: 
For example, you want to only count rows that fulfill a certain condition. 
Since COUNT ignores nulls, you could use a CASE statement to evaluate the condition 
and produce null or non-null values depending on the outcome:*/
  SELECT CASE WHEN year = 'FR' THEN 'FR'
            ELSE 'Not FR' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
 GROUP BY CASE WHEN year = 'FR' THEN 'FR'
               ELSE 'Not FR' END
               
/* Here’s an example of counting multiple conditions in one query:*/

SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
 GROUP BY 1              

/* print  hacker_id and name of hackers who achieved full scores for more than one challenge. 
output in descending order by the total number of challenges in which the hacker earned a full score. 
If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.
Hackers: hacker_id, name
Difficulty: difficult_level, score (score of the challenge)
Challenges: challenge_id, hacker_id (hacker who created the challenge), difficulty_level
Submissions: submission_id, hacker_id (hacker who made the submission), challenge_id, score (score of the submission)
*/


select H.hacker_id, H.name
from Hackers H, Submissions S, Difficulty D, Challenges C
where H.hacker_id = S.hacker_id and D.difficulty_level = C.difficulty_level 
and C.challenge_id = S.challenge_id
and D.score = S.score
group by H.hacker_id, H.name
having count(H.hacker_id) > 1
order by count(H.hacker_id) desc, H.hacker_id


select h.hacker_id, h.name
from hackers h
inner join submissions s
on h.hacker_id = s.hacker_id
inner join challenges c
on s.challenge_id = c.challenge_id
inner join difficulty d
on c.difficulty_level = d.difficulty_level
where s.score = d.score
group by h.hacker_id, h.name
having count(s.hacker_id) > 1
order by count(h.hacker_id) desc, h.hacker_id asc


select s.hacker_id, h.name
from submissions s join hackers h on s.hacker_id = h.hacker_id
join challenges c on s.challenge_id = c.challenge_id
join difficulty d on c.difficulty_level = d.difficulty_level 
where s.score = d.score
group by s.hacker_id, h.name
having count(s.challenge_id) > 1
order by count(s.challenge_id) desc, s.hacker_id

/* Follow-up
total score of a hacker = the sum of their maximum scores for all of the challenges.
Print hacker_id, name, total score of the hackers ordered by the desc score, asce hacker_id. 
Exclude all hackers with a total score of 0.
*/

/* first step*/
select h.hacker_id, name, challenge_id, score
from hackers h inner join submissions s on h.hacker_id = s.hacker_id
order by h.hacker_id, name, challenge_id, score desc

/* second step*/
/* wrong code: Column 'hackers.hacker_id' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause. */
select h.hacker_id, name, challenge_id, max(score)
from hackers h inner join submissions s on h.hacker_id = s.hacker_id
order by h.hacker_id, name, challenge_id

/* correct */
select h.hacker_id, name, challenge_id, max(score)
from hackers h inner join submissions s on h.hacker_id = s.hacker_id
group by h.hacker_id, name, challenge_id
having max(score) > 0


/* third step*/
select hacker_id, name, sum(maxscore)
from
(select h.hacker_id, name, challenge_id, max(score) as maxscore
from hackers h inner join submissions s on h.hacker_id = s.hacker_id
group by h.hacker_id, name, challenge_id
having max(score) > 0) t
group by hacker_id, name
order by sum(maxscore) desc, hacker_id      

/* find the minimum number of coins_needed to buy each non-evil wand of high power and age. 
print the id, age, coins_needed, and power of the wands, 
sorted in order of descending power, and then descending age.

Wands: id (wand), code (wand), coins_needed, power
Wands_Property: code (wand), age (wand), is_evil (0, 1)
The mapping between code and age is one-one */

select id, age, coins_needed, power 
from wands w join wands_property p on w.code = p.code 
where is_evil=0 
and coins_needed =(select min(coins_needed) from wands w2 where w2.power=w.power and w2.code=w.code) 
order by power desc,age desc

/* Basic Join - Challenges
print the hacker_id, name, and the total number of challenges created by each student. 
Sort by the total number of challenges in descending order, then by hacker_id. 
If more than one student created the same number of challenges and the count 
is less than the maximum number of challenges created, then exclude those students 
from the result.
Hackers: hacker_id, name
Challenges: challenge_id, hacker_id */

/* wrong solution*/
select C.hacker_id, name, count(challenge_id) 
from Hackers H join Challenges C on H.hacker_id = C.hacker_id
group by C.hacker_id, name
order by count(challenge_id) desc, C.hacker_id desc

/***  ****/

select h.hacker_id, name, count(challenge_id)
from Challenges c inner join Hackers h on h.hacker_id = c.hacker_id
group by h.hacker_id, h.name
/* having is required (instead of where) for filtering on groups */
having 
count(challenge_id) = 
/* the max count that anyone has */
(select max(temp.cnt)
from (select count(challenge_id) as cnt 
      from Challenges
      group by hacker_id) temp)
      /* or anyone who's count is in... */
or count(challenge_id) in 
(select t.cnt
 from (select count(*) as cnt 
        from challenges
        group by hacker_id) t
        /* who's group of counts has only one element */
        group by t.cnt
        having count(t.cnt) = 1)
order by count(challenge_id) desc, h.hacker_id


/* 
Projects: Task_ID, Start_Date, End_Date. 
The difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
If the End_Date of the tasks are consecutive, then they are part of the same project. 
Find the total number of different projects completed.
Output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. 
If there is more than one project that have the same number of completion days, then order by the start date of the project.*/

/* step 1 */

select start_date, end_date
from Projects

2015-10-01 2015-10-02 
2015-10-02 2015-10-03 
2015-10-03 2015-10-04 
2015-10-04 2015-10-05 
2015-10-11 2015-10-12 
2015-10-12 2015-10-13 
2015-10-15 2015-10-16 
2015-10-17 2015-10-18 
2015-10-19 2015-10-20 
2015-10-21 2015-10-22 
2015-10-25 2015-10-26 
2015-10-26 2015-10-27 
2015-10-27 2015-10-28 
2015-10-28 2015-10-29 
2015-10-29 2015-10-30 
2015-10-30 2015-10-31 
2015-11-01 2015-11-02 
2015-11-04 2015-11-05 
2015-11-07 2015-11-08 
2015-11-06 2015-11-07 
2015-11-05 2015-11-06 
2015-11-11 2015-11-12 
2015-11-12 2015-11-13 
2015-11-17 2015-11-18 

/* step 2 */
select start_date, end_date
from
(select start_date from Projects where start_date not in (select end_date from Projects)) a,
(select end_date from Projects where end_date not in (select start_date from Projects)) b
where start_date < end_date
group by start_date, end_date

2015-10-01 2015-10-05 
2015-10-01 2015-10-13 
2015-10-01 2015-10-16 
2015-10-01 2015-10-18 
2015-10-01 2015-10-20 
2015-10-01 2015-10-22 
2015-10-01 2015-10-31 
2015-10-01 2015-11-02 
2015-10-01 2015-11-08 
2015-10-01 2015-11-13 
2015-10-01 2015-11-18 
2015-10-11 2015-10-13 
2015-10-11 2015-10-16 
2015-10-11 2015-10-18 
2015-10-11 2015-10-20 
2015-10-11 2015-10-22 
2015-10-11 2015-10-31 
2015-10-11 2015-11-02 
2015-10-11 2015-11-08 
2015-10-11 2015-11-13 
2015-10-11 2015-11-18 
2015-10-15 2015-10-16 

/* step 3 */
select start_date, min(end_date)
from
(select start_date from Projects where start_date not in (select end_date from Projects)) a,
(select end_date from Projects where end_date not in (select start_date from Projects)) b
where start_date < end_date
group by start_date

/* step 4 */
select start_date, min(end_date)
from
(select start_date from Projects where start_date not in (select end_date from Projects)) a,
(select end_date from Projects where end_date not in (select start_date from Projects)) b
where start_date < end_date
group by start_date
order by datediff(day, start_date, min(end_date)), start_date

/*
Students: ID and Name. 
Friends: ID and Friend_ID (ID of the ONLY best friend). 
Packages: ID and Salary (offered salary in $ thousands per month).
output the names of students whose best friends got offered a higher salary than them. 
Names must be ordered by the salary amount offered to the best friends. 
It is guaranteed that no two students got same salary offer.
*/

select name
from Students s 
join Friends f on s.ID = f.ID
join Packages p1 on s.ID = p1.ID
join Packages p2 on f.Friend_ID = p2.ID
where p2.salary > p1.salary
order by p2.salary

/*
Functions: X and Y. Y = F(X).
Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.
output all such symmetric pairs in ascending order by the value of X.
*/
/* wrong code: single pair (X, Y) where X=Y should be excluded */
select f1.X, f1.Y
from Functions f1, Functions f2
where f1.X = f2.Y and f1.Y = f2.X
order by f1.X, f1.Y 

/* correct code */
select f1.X, f1.Y
from Functions f1, Functions f2
where f1.X = f2.Y and f1.Y = f2.X and f1.X<=f1.Y
group by f1.X, f1.Y 
having count(*) > 1 or (count(*) = 1 and f1.X != f1.Y)
order by f1.X

/* reference code */
select f1.x, f1.y from functions f1
inner join functions f2 on f2.y = f1.x
where f1.y >= f1.x and f2.x = f1.y
group by f1.x, f1.y
having count(*) > 1 or (count(*) = 1 and f1.y != f1.x)
order by f1.x


/* Interviews: 
Print the contest_id, hacker_id, name, and the sums of total_submissions, 
total_accepted_submissions, total_views, and total_unique_views for each contest 
sorted by contest_id. Exclude the contest from the result if all four sums are .
Note: A specific contest can be used to screen candidates at more than one college, 
but each college only holds one screening contest.

Contests: contest_id, hacker_id(created the contest), name
Colleges: college_id, contest_id (id of the contest that Samantha used to screen the candidates.)
Challenges: challenge_id (belongs to one of the contests whose contest_id Samantha forgot), college_id is the id of the college where the challenge was given to candidates.
View_Stats: challenge_id, total_views is the number of times the challenge was viewed by candidates, and total_unique_views is the number of times the challenge was viewed by unique candidates.
Submission_Stats: challenge_id, total_submissions is the number of submissions for the challenge, and total_accepted_submission is the number of submissions that achieved full scores.
*/
/*wrong code: why? got duplicates of college id and challenge_id. 
How? because some colleges use same challenges */
select con.contest_id, hacker_id, name, sum(total_submissions), 
sum(total_accepted_submissions), sum(total_views), sum(total_unique_views)
from Contests con
join Colleges col on con.contest_id = col.contest_id
join Challenges cha on col.college_id = cha.college_id
join View_Stats vs on vs.challenge_id = cha.challenge_id
join Submission_Stats ss on ss.challenge_id = cha.challenge_id
group by con.contest_id, hacker_id, name
having (sum(total_submissions)
		+sum(total_accepted_submissions)
		+sum(total_views)+
		sum(total_unique_views)) <> 0
order by con.contest_id

/*reference code */
WITH SUM_View_Stats AS (
SELECT challenge_id
    , total_views = sum(total_views)
    , total_unique_views = sum(total_unique_views)
FROM View_Stats 
GROUP BY challenge_id
)
,SUM_Submission_Stats AS (
SELECT challenge_id
    , total_submissions = sum(total_submissions)
    , total_accepted_submissions = sum(total_accepted_submissions)
FROM Submission_Stats 
GROUP BY challenge_id
)

SELECT  con.contest_id
        , con.hacker_id
        , con.name
        , sum(total_submissions)
        , sum(total_accepted_submissions)
        , sum(total_views)
        , sum(total_unique_views)
FROM Contests con
INNER JOIN Colleges col
    ON con.contest_id = col.contest_id
INNER JOIN Challenges cha
    ON cha.college_id = col.college_id
LEFT JOIN SUM_View_Stats vs
    ON vs.challenge_id = cha.challenge_id
LEFT JOIN SUM_Submission_Stats ss
    ON ss.challenge_id = cha.challenge_id
GROUP BY con.contest_id,con.hacker_id,con.name
HAVING (sum(total_submissions)
        +sum(total_accepted_submissions)
        +sum(total_views)
        +sum(total_unique_views)) <> 0
ORDER BY con.contest_ID


/* Advanced Select:  Type of Triangle
Identify the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table:
Not A Triangle: The given values of A, B, and C don't form a triangle.
Equilateral: It's a triangle with 3 sides of equal length.
Isosceles: It's a triangle with 2 sides of equal length.
Scalene: It's a triangle with 3 sides of differing lengths.

TRIANGLES: A, B, C */
select case when A=B and B=C and A=C then 'Equilateral'
			when (A=B and A+B>C) or (B=C and C+B>A) or (A=C and A+C>B) then 'Isosceles'
			when A+B<=C or B+C<=A or A+C<=B then 'Not A Triangle'
			else 'Scalene' end as type 
from TRIANGLES


/* Advanced Select  The PADS
Generate the following two result sets:

1. Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed 
by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). 
For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).

2. Query the number of ocurrences of each occupation in OCCUPATIONS. 
Sort the occurrences in ascending order, and output them in the following format: 

There are total [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS 
and [occupation] is the lowercase occupation name. If more than one Occupation has the 
same [occupation_count], they should be ordered alphabetically.

Note: There will be at least two entries in the table for each type of occupation.

Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

Sample Output

Ashely(P)
Christeen(P)
Jane(A)
Jenny(D)
Julia(A)
Ketty(P)
Maria(A)
Meera(S)
Priya(S)
Samantha(D)
There are total 2 doctors.
There are total 2 singers.
There are total 3 actors.
There are total 3 professors.
*/
/* alternative solution for query 1 */
Select concat(Name,'(' , LEFT(Occupation,1),')') 
from OCCUPATIONS 
ORDER BY Name;


select concat(name, case when occupation = 'Professor' then '(P)'
                  when occupation = 'Doctor' then '(D)'
                  when occupation = 'Singer' then '(S)'
                  when occupation = 'Actor' then '(A)' end)
from occupations
order by name;

select 'There are total', count(occupation), concat(lower(occupation), 's.')
from occupations
group by occupation
order by count(occupation), occupation;


/*  Advanced Select : Occupations
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically
 and displayed underneath its corresponding Occupation. 
 The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
 Note: Print NULL when there are no more names corresponding to an occupation.
OCCUPATIONS: Name, Occupation
*/
Ashley Professor 
Samantha Actor 
Julia Doctor 
Britney Professor 
Maria Professor 
Meera Professor 
Priya Doctor 
Priyanka Professor 
Jennifer Actor 
Ketty Actor 
Belvet Professor 
Naomi Professor 
Jane Singer 
Jenny Singer 
Kristeen Singer 
Christeen Singer 
Eve Actor 
Aamina Doctor 

/* set pivot number for each row */
select  case when occupation = 'Doctor' then @d:=@d+1
			 when occupation = 'Professor' then @p:=@p+1
			 when occupation = 'Singer' then @s:=@s+1
			 when occupation = 'Actor' then @a:=@a+1 end as row
from Occupations join (select @d:=0, @p:=0, @s:=0,@a:=0) as r 	

1 1 1 2 3 4 2 5 2 3 6 7 1 2 3 4 4 3 (transposed for easy-review)

/* */
select  case when occupation = 'Doctor' then @d:=@d+1
			 when occupation = 'Professor' then @p:=@p+1
			 when occupation = 'Singer' then @s:=@s+1
			 when occupation = 'Actor' then @a:=@a+1 end as row,
		case when occupation = 'Doctor' then name end as Doctor,
		case when occupation = 'Professor' then name end as Professor,
		case when occupation = 'Singer' then name end as Singer,
		case when occupation = 'Actor' then name end as Actor
from Occupations join (select @d:=0, @p:=0, @s:=0,@a:=0) as r 		
order by name

1 Aamina NULL NULL NULL 
1 NULL Ashley NULL NULL 
2 NULL Belvet NULL NULL 
3 NULL Britney NULL NULL 
1 NULL NULL Christeen NULL 
1 NULL NULL NULL Eve 
2 NULL NULL Jane NULL 
2 NULL NULL NULL Jennifer 
3 NULL NULL Jenny NULL 
2 Julia NULL NULL NULL 
3 NULL NULL NULL Ketty 
4 NULL NULL Kristeen NULL 
4 NULL Maria NULL NULL 
5 NULL Meera NULL NULL 
6 NULL Naomi NULL NULL 
3 Priya NULL NULL NULL 
7 NULL Priyanka NULL NULL 
4 NULL NULL NULL Samantha 

SELECT
   MIN(o.Doctor),MIN(o.Professor),MIN(o.Singer),MIN(o.Actor)
FROM
    (SELECT
        CASE WHEN occupation='Doctor' THEN @d:=@d+1
             WHEN occupation='Professor' THEN @p:=@p+1
             WHEN occupation='Singer' THEN @s:=@s+1
             WHEN occupation='Actor' THEN @a:=@a+1 END AS row,
        CASE WHEN occupation='Doctor' THEN name END AS Doctor,
        CASE WHEN occupation='Professor' THEN name END AS Professor,
        CASE WHEN occupation='Singer' THEN name END AS Singer,
        CASE WHEN occupation='Actor' THEN name END AS Actor
     FROM occupations JOIN (SELECT @d:=0, @p:=0, @s:=0,@a:=0) AS r 
     ORDER BY name) o
GROUP BY row;
	
Aamina Ashley Christeen Eve 
Julia Belvet Jane Jennifer 
Priya Britney Jenny Ketty 
NULL Maria Kristeen Samantha 
NULL Meera NULL NULL 
NULL Naomi NULL NULL 
NULL Priyanka NULL NULL 	
	
set @r1=0, @r2=0, @r3=0, @r4=0;
select min(Doctor), min(Professor), min(Singer), min(Actor)
from(
  select case when Occupation='Doctor' then (@r1:=@r1+1)
            when Occupation='Professor' then (@r2:=@r2+1)
            when Occupation='Singer' then (@r3:=@r3+1)
            when Occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
    case when Occupation='Doctor' then Name end as Doctor,
    case when Occupation='Professor' then Name end as Professor,
    case when Occupation='Singer' then Name end as Singer,
    case when Occupation='Actor' then Name end as Actor
  from OCCUPATIONS
  order by Name
) Temp
group by RowNumber	


/*  Advanced Select  Binary Tree Nodes*/



/*  Aggregation :Top Earners
total earnings = salary * month, 
find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. 
Employee: employee_id, name, months, salary
*/
/* MS SQL server*/
with temp as (
    select employee_id, months*salary as earnings
    from Employee
)
select max(earnings), count(earnings)
from temp
where earnings = (select max(earnings) from temp)

/* MySQL */
select salary*months, count(salary*months)
from Employee
group by salary*months 
order by salary*months desc
limit 1

/*  Aggregation  Weather Observation Station 2
Query the following two values from the STATION table:
The sum of all values in LAT_N rounded to a scale of 2 decimal places.
The sum of all values in LONG_W rounded to a scale of 2 decimal places.
STATION : id, city, state, lat_n, long_w
*/
select cast(sum(lat_n) as decimal(18,2)) as lat, cast(sum(long_w) as decimal(18,2))  as lon
from station

/* Aggregation  Weather Observation Station 13
Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 
and less than 137.2345. Truncate your answer to 4 decimal places.
*/
select cast(sum(lat_n) as decimal(18,4)) as lat
from station
where lat_n > 38.7880 and lat_n < 137.2345

/* Aggregation  Weather Observation Station 14
Query the greatest value of the Northern Latitudes (LAT_N) from STATION 
that is less than 137.2345.Truncate your answer to 4 decimal places.
*/
select cast(max(lat_n) as decimal(18,4))
from station
where lat_n < 137.2345

/* Aggregation  Weather Observation Station 15
Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) 
in STATION that is less than 137.2345.Truncate your answer to 4 decimal places.
*/
select cast(long_w as decimal(18,4))
from station
where lat_n =  (select max(lat_n)
				from station
				where lat_n < 137.2345)

/* Aggregation  Weather Observation Station 16
Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7880.
Truncate your answer to 4 decimal places.
*/
select cast(min(lat_n) as decimal(18,4))
from station
where lat_n > 38.7880

/* Aggregation  Weather Observation Station 17
Query the Western Longitude (LONG_W) for the smallest Northern Latitude (LAT_N) 
in STATION that is greater than 38.7880. Truncate your answer to 4 decimal places.
*/
select cast(long_w as decimal(18,4))
from station
where lat_n =  (select min(lat_n)
				from station
				where lat_n > 38.7880)
				
				
/* Aggregation  Weather Observation Station 17
Consider P1(a,b) and P2(a,b) to be two points on a 2D plane.
 a equal the minimum value in (LAT_N in STATION).
 b equal the minimum value in  (LONG_W in STATION).
 c equal the maximum value in  (LAT_N in STATION).
 d equal the maximum value in  (LONG_W in STATION).
Query the Manhattan Distance between points P1 and P2  and round it to a scale of 4 decimal places.
*/				

select cast(max(LAT_N) - min(LAT_N) + max(LONG_W) - min(LONG_W) as decimal(18,4))
from station