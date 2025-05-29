--Pregunta1

SELECT id, title
 FROM movie
 WHERE yr=1962

--Pregunta2

select yr
from movie
where title ='Citizen Kane'

-Pregunta3

select id,title,yr
from movie
where title like 'Star Trek%'
Order by yr 

--Pregunta4

Select id 
from actor
where name = 'Glenn Close' 

--Pregunta5

Select id
from movie
Where title = 'Casablanca'

--Pregunta6

Select id
from movie
Where title = 'Casablanca'

--Pregunta7

select name
from casting c left join actor a on c.actorid = a.id
where movieid=10522

--Pregunta8

select title from casting c left join movie m on c.movieid = m.id
where actorid = (select id from actor where name = 'Harrison Ford' )

--Pregunta9

Select m.title
From movie m
Join casting c ON m.id = c.movieid
Join actor a ON c.actorid = a.id
Where a.name = 'Harrison Ford' AND c.ord != 1;

--Pregunta10

Select title,name
From movie
Join casting
Join actor
where casting.ord = 1
and movie.id = casting.movieid
and actor.id = casting.actorid
and movie.yr =1962


