/*** SQL Movie-Rating Query Exercises Extras ***/

/* Q1. Find the names of all reviewers who rated Gone with the Wind. */
select distinct name
from Reviewer, Rating
where Reviewer.rID = Rating.rID
and mID in (select mID from Movie where title = 'Gone with the Wind');

select distinct name
from Reviewer, Rating, Movie
where Reviewer.rID = Rating.rID
and Rating.mID = Movie.mID
and title = 'Gone with the Wind';

/* Q2. For any rating where the reviewer is the same as the director of 
the movie, return the reviewer name, movie title, and number of stars. */

select name, title, stars
from Reviewer, Movie, Rating
where Reviewer.rID = Rating.rID and Movie.mID=Rating.mID
and name=director;


/* Q3. Return all reviewer names and movie names together in a single 
list, alphabetized. (Sorting by the first name of the reviewer and 
first word in the title is fine; no need for special processing on 
last names or removing "The".) */

select name
from Reviewer
union 
select title
from Movie; 

/* Q4. Find the titles of all movies not reviewed by Chris Jackson. */

select title
from Movie
where mID not in 
(select mID from Rating 
 where rID in (select rID from Reviewer where name='Chris Jackson'));


/* Q5. For all pairs of reviewers such that both reviewers gave a rating 
to the same movie, return the names of both reviewers. Eliminate duplicates, 
don't pair reviewers with themselves, and include each pair only once. 
For each pair, return the names in the pair in alphabetical order. */

select t1.name, t2.name
from (select * from Reviewer inner join Rating on Reviewer.rID=Rating.rID) t1,
(select * from Reviewer inner join Rating on Reviewer.rID=Rating.rID) t2
where t1.mID = t2.mID and t1.name < t2.name
group by t1.name, t2.name;


/* Q6. For each rating that is the lowest (fewest stars) currently in the 
database, return the reviewer name, movie title, and number of stars. */
select name, title, stars
from Reviewer, Movie, Rating
where Reviewer.rID = Rating.rID and Movie.mID = Rating.mID
and stars = (select min(stars) from Rating);

/* Q7. List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */
select title, avg(stars)
from Movie, Rating
where Movie.mID = Rating.mID
group by title
order by avg(stars) DESC, title;


/* Q8. Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */

select name
from Reviewer, Rating
where Reviewer.rID = Rating.rID
group by Rating.rID
having count(Rating.rID) >=3;


/* Q9. Some directors directed more than one movie. For all such directors, 
return the titles of all movies directed by them, along with the director name. 
Sort by director name, then movie title. (As an extra challenge, try writing the 
query both with and without COUNT.) */

select title, director
from Movie
where director in
(select director
from Movie 
group by director
having count(director) > 1)
order by director, title;


/* Q10. Find the movie(s) with the highest average rating. Return the 
movie title(s) and average rating. (Hint: This query is more difficult 
to write in SQLite than other systems; you might think of it as finding 
the highest average rating and then choosing the movie(s) with that 
average rating.) */

select title, A
from (select title , avg(stars) as A
	  from Movie, Rating
	  where Movie.mID = Rating.mID
	  group by title
	  order by A)
where A = (select max(A)
		   from (select title , avg(stars) as A
				 from Movie, Rating
				 where Movie.mID = Rating.mID
				 group by title
				 order by A));
		  
		  
/* Q11. Find the movie(s) with the lowest average rating. Return the 
movie title(s) and average rating. (Hint: This query may be more difficult 
to write in SQLite than other systems; you might think of it as finding the 
lowest average rating and then choosing the movie(s) with that average rating.) */

/* Note that if you use limit 1, you will only select one of the movies 
with the lowest average rating. */

select title, A
from (select title , avg(stars) as A
	  from Movie, Rating
	  where Movie.mID = Rating.mID
	  group by title
	  order by A)
where A = (select min(A)
		   from (select title , avg(stars) as A
				 from Movie, Rating
				 where Movie.mID = Rating.mID
				 group by title
				 order by A));


/* Q12. For each director, return the director's name together with 
the title(s) of the movie(s) they directed that received the highest 
rating among all of their movies, and the value of that rating. 
Ignore movies whose director is NULL. */

select director, title, stars
from Movie, Rating
where Movie.mID = Rating.mID
and director is not null
group by director;

