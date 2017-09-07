
/*** SQL Movie-Rating Query Exercises ***/

/* create a new database */
$ sqlite3 Movie.db 

sqlite> .databases

/* create tables */
sqlite> .read rating.sql
sqlite> .tables

/*  show column names of a table */
sqlite> PRAGMA table_info(Movie);
sqlite> .schema Movie

/* Q1. Find the titles of all movies directed by Steven Spielberg. */

select title
from Movie
where director = 'Steven Spielberg';

/* Q2. Find all years that have a movie that received a rating of 4 or 5,
 and sort them in increasing order. */

select year
from Movie
where mID in (select mID from Rating 
			  where stars = 4 or stars = 5)
order by year;

/* Q3. Find the titles of all movies that have no ratings. */

select title
from Movie
where mID not in (select mID from Rating);

/* Q4. Some reviewers didn't provide a date with their rating. 
Find the names of all reviewers who have ratings with a NULL value for the date.*/ 

select name
from Reviewer
where rID in (select rID from Rating
			  where ratingDate is null);

/* Q5. Write a query to return the ratings data in a more readable format: 
reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
first by reviewer name, then by movie title, and lastly by number of stars.*/ 

select name, title, stars, ratingDate
from Reviewer, Movie, Rating
where Reviewer.rID = Rating.rID and Movie.mID = Rating.mID
order by name, title, stars;


/* Q6. For all cases where the same reviewer rated the same movie twice 
and gave it a higher rating the second time, return the reviewer's name
 and the title of the movie. */

select distinct name, title
from Reviewer, Movie, Rating
where Reviewer.rID=Rating.rID and Movie.mID=Rating.mID
and Reviewer.rID in (select R1.rID from Rating R1, Rating R2 
where R1.rID = R2.rID and R1.mID = R2.mID and R2.ratingDate > R1.ratingDate and R2.stars > R1.stars);


/* Q7. For each movie that has at least one rating, find the highest number 
of stars that movie received. Return the movie title and number of stars.
 Sort by movie title. */
 
select title, stars
from Movie, Rating
where Movie.mID=Rating.mID
group by Movie.mID
order by title;

/* Q8. For each movie, return the title and the 'rating spread', that is, 
the difference between highest and lowest ratings given to that movie. 
Sort by rating spread from highest to lowest, then by movie title.*/

/* do query to picture grouping */
select title, stars
from Movie, Rating
where Movie.mID=Rating.mID
order by title;

select title, max(stars), min(stars)
from Movie, Rating
where Movie.mID=Rating.mID
group by title;

/* now solve the problem */
select title, mx-mn as rating_spread
from (select title, max(stars) as mx, min(stars) as mn
from Movie, Rating
where Movie.mID=Rating.mID
group by title) M
order by rating_spread DESC, title;


/* Q9. Find the difference between the average rating of movies released 
before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average 
of those averages for movies before 1980 and movies after. Don't just calculate 
the overall average rating before and after 1980.) */

/* first calculate the average rating for each movie and sort by year */
select Rating.mID, avg(stars), year 
from Rating, Movie
where Rating.mID = Movie.mID
group by Rating.mID
order by year;

/* now go to what we want */
select avg(avg_star1) - avg(avg_star2)
from (select Rating.mID, avg(stars) as avg_star1
	from Rating, Movie
	where Rating.mID = Movie.mID and year < 1980
	group by Rating.mID) R1,
(select Rating.mID, avg(stars) as avg_star2
	from Rating, Movie
	where Rating.mID = Movie.mID and year >= 1980
	group by Rating.mID) R2



