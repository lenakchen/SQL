/**************************************************************
  SUBQUERIES IN THE WHERE CLAUSE
  Works for MySQL, Postgres
  SQLite doesn't support All or Any
**************************************************************/

/**************************************************************
  IDs and names of students applying to CS
**************************************************************/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Same query written without 'In'
**************************************************************/

select Student.sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/* The additional results are actually duplicate values.
The reason for that is that Amy actually applied to
major in CS at multiple colleges. */

/*** Remove duplicates ***/

select distinct Student.sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/**************************************************************
  Just names of students applying to CS
**************************************************************/

select sName
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Same query written without 'In'
**************************************************************/

select sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS'; /*** got duplicate names***/

/*** Remove duplicates (still incorrect) ***/

select distinct sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/**************************************************************
  Duplicates are important: average GPA of CS applicants
**************************************************************/

select GPA
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Alternative (incorrect) queries without 'In'
**************************************************************/

select GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';
/* Because we have students who applied multiple
times for CS, we have duplicates. 
When we do the join, we get too many results.
But this time, again, we're going to have a problem 
when we do select distinct, 
because some of these students have the same GPA.*/

select distinct GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*The only way to get the correct number of duplicates 
is to use the version of the query that has the sub-query 
in the where clause.*/

/**************************************************************
  Students who applied to CS but not EE
  (query we used 'Except' for earlier)
**************************************************************/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and sID not in (select sID from Apply where major = 'EE');

/*** Change to 'not sID in' ***/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and not sID in (select sID from Apply where major = 'EE');

/**************************************************************
  Colleges such that some other college is in the same state
**************************************************************/

select cName, state
from College C1
where exists (select * from College C2
              where C2.state = C1.state);
              
/*** Fix error ***/

select cName, state
from College C1
where exists (select * from College C2
              where C2.state = C1.state and C2.cName <> C1.cName);
/* This query uses exists to check
whether a subquery is empty or not empty rather than checking
whether values are in the subquery. 
The query is going to find all colleges, 
such that there's some other college that is in the same state.
*/


/**************************************************************
  Biggest college
**************************************************************/

select cName, enrollment
from College C1
where not exists (select * from College C2
                  where C2.enrollment > C1.enrollment);

/*** Similar: student with highest GPA  ***/

select sName
from Student C1
where not exists (select * from Student C2
                  where C2.GPA > C1.GPA);

/*** Add GPA ***/

select sName, GPA
from Student C1
where not exists (select * from Student C2
                  where C2.GPA > C1.GPA);

/**************************************************************
  Highest GPA with no subquery
**************************************************************/

select S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;

/*** Remove duplicates (still incorrect) ***/

select distinct S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;

/* What this query actually does is it finds all 
students  such that there is some other student 
whose GPA is lower.
In other words, it's finding all students except 
those who have the lowest GPA. */

/**************************************************************
  Highest GPA using ">= all"
**************************************************************/

select sName, GPA
from Student
where GPA >= all(select GPA from Student);

/**************************************************************
  Higher GPA than all other students
**************************************************************/

select sName, GPA
from Student S1
where GPA > all (select GPA from Student S2
                 where S2.sID <> S1.sID);

/* The query is looking for all students where 
nobody else has the same GPA as that student.
Everybody else's GPA is lower. */

/*** Similar: higher enrollment than all other colleges  ***/

select cName
from College S1
where enrollment > all (select enrollment from College S2
                        where S2.cName <> S1.cName);

/*** Same query using 'Not <= Any' ***/

select cName
from College S1
where not enrollment <= any (select enrollment from College S2
                             where S2.cName <> S1.cName);

/**************************************************************
  Students not from the smallest HS
**************************************************************/

select sID, sName, sizeHS
from Student
where sizeHS > any (select sizeHS from Student);

/**************************************************************
  Students not from the smallest HS
  Some systems don't support Any/All
**************************************************************/

select sID, sName, sizeHS
from Student S1
where exists (select * from Student S2
              where S2.sizeHS < S1.sizeHS);
/*** It turns out we can always write
a query that would use any or all by using 
the exists operator or not exists instead.***/              

/**************************************************************
  Students who applied to CS but not EE : tricky using ANY
**************************************************************/

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
  and sID <> any (select sID from Apply where major = 'EE');

/*** What we're saying here is that we want 
the condition to check whether there's any element 
in the set of EE's that are not equal to this SID.
This second condition is satisfied as long as
there's anybody who applied to EE that's not equal to
the student we're looking at. 
(select sID from Apply where major = 'EE') returns 123,345
(select sID from Apply where major = 'CS') returns 123,345,987,876,543
***/
/*** Subtle error, fix ***/

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
  and not sID = any (select sID from Apply where major = 'EE');
