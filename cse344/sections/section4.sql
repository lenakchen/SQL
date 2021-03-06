-- CSE 344 section 04 
-- Nested Queries: the drinker-bar-beer example


-- The schema we use is the following: 
--  Likes (name, beer)
--  Serves (bar, beer)
--  Frequents (name, bar)


-- Find the drinkers that frequent some bar that serves some beer they like.
-- Relational Algebra:
--   x:  exists y. exists z. ( Frequents(x, y), Serves(y,z), Likes(x,z) )

SELECT DISTINCT l.name 
FROM Likes l, Serves s, Frequents f
WHERE l.name = f.name AND
      s.bar = f.bar AND
      l.beer = s.beer;


-- Find the drinkers that frequent only bars that serve some beer they like.
-- Relational Algebra:
--   x: forall y. ( Frequents(x, y) => (exists z. Serves(y,z),Likes(x,z)))
 
SELECT name 
FROM Frequents
EXCEPT 
 (SELECT f.name 
  FROM Frequents f
  WHERE f.bar NOT IN
      (SELECT s.bar 
       FROM Likes l, Serves s 
       WHERE l.beer = s.beer AND 
             l.name=f.name ) 
) ;

 
-- Find the drinkers that frequent some bar that serves only beers they like.
-- Relational Algebra:
--   x: exists y. ( Frequents(x, y), (forall z.(Serves(y,z) => Likes(x,z)) ) )
 
SELECT DISTINCT f.name 
FROM Frequents f
WHERE f.bar NOT IN 
  (SELECT s.bar 
   FROM Likes l, Serves s
   WHERE l.name =  f.name AND 
         s.beer NOT IN 
                (SELECT beer 
	             FROM Likes ll 
	             WHERE ll.name = l.name )
  ) ;



-- Find the drinkers that frequent only bars that serve only beer they like.
-- Relational Algebra:
--   x:forall y. (Frequents(x, y) => (forall z.(Serves(y,z) => Likes(x,z))) )
 
SELECT name 
FROM Frequents
EXCEPT
(SELECT f.name 
 FROM Frequents f 
 WHERE f.bar IN
  (SELECT s.bar 
   FROM Likes l, Serves s
   WHERE l.name =  f.name AND 
         s.beer NOT IN 
            (SELECT beer 
	         FROM Likes ll 
	         WHERE ll.name = l.name)
  )
) ;
