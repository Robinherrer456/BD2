1. 

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'

2.

SELECT id,stadium,team1,team2
  FROM game
WHERE id = 1012

3.

SELECT goal.player, goal.teamid, game.stadium, game.mdate
  FROM game JOIN goal ON (id=matchid)
WHERE teamid = 'GER'

4.

SELECT team1, team2, player
FROM game JOIN goal ON (id = matchid)
WHERE player LIKE 'Mario%'

5.

SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON teamid = id
 WHERE gtime<=10

6.

SELECT mdate, teamname
FROM game ON eteam ON (team1 = eteam.id)
WHERE coach = 'Fernando Santos'

7.

SELECT player 
FROM game JOIN goal ON (id = matchid)
WHERE stadium = 'National Stadium, Warsaw'

8.

SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' OR team2='GER') AND teamid!='GER'

9.

SELECT teamname, count(*)
  FROM eteam JOIN goal ON id=teamid
 GROUP BY teamname

10.

SELECT stadium, count(*)
FROM game JOIN goal ON (id=matchid)
GROUP BY stadium

11.

SELECT matchid,mdate, count(*)
FROM game JOIN goal ON (matchid = id) 
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matched

12.

SELECT matchid, mdate, count(teamid)
 FROM game JOIN goal ON (matchid = id)
  WHERE(team1 = 'GER' OR team2 = 'GER')
   GROUP BY matchid

