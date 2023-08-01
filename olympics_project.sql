-- brief look into the data
SELECT *
FROM olympics
LIMIT 10;



-- calculating top 10 countries by total medals, over all time
SELECT Country, COUNT(Medal) AS medal_count
FROM olympics
GROUP BY Country
ORDER BY medal_count DESC
LIMIT 10;



-- the result from the above query is interesting, but we may want to group Russia
-- and the Soviet Union together, along with Germany and East Germany.
CREATE OR REPLACE VIEW modified_countries AS (
SELECT *, 
	CASE WHEN Country = 'Soviet Union' THEN 'Russia/Soviet Union'
		 WHEN Country = 'Russia' THEN 'Russia/Soviet Union'
		 WHEN Country = 'Germany' THEN 'Germany'
		 WHEN Country = 'East Germany' THEN 'Germany'
    ELSE Country END AS updated_country
FROM olympics);

SELECT *
FROM modified_countries
LIMIT 10;

SELECT updated_country AS country, COUNT(Medal) AS medal_count
FROM modified_countries
GROUP BY updated_country
ORDER BY medal_count DESC
LIMIT 10;



-- find top 10 athletes by gold medal count
SELECT Athlete, COUNT(Medal) AS gold_medals, MAX(Year) AS final_year
FROM olympics
WHERE Medal = 'Gold'
GROUP BY Athlete
ORDER BY gold_medals DESC
LIMIT 10;



-- which sports have had the most athlete participants from 1976 - 2008
SELECT Sport, COUNT(Year) AS total_athletes
FROM olympics
GROUP BY Sport
ORDER BY total_athletes DESC
LIMIT 15;



-- looking at yearly count of athletes grouped by 'gender' to see how numbers have changed over the years
SELECT Year, Gender, COUNT(Year) AS num_athletes
FROM olympics
GROUP BY Year, Gender
ORDER BY Year, Gender;



-- counting the three types of medals from 1976 - 2008 by discipline
SELECT Discipline, Medal, COUNT(*)
FROM olympics
GROUP BY Discipline, Medal;



-- added new small CSV, can utilize to join to main table
SELECT *
FROM city_country;



-- find the number of times an Olympics was held in each continent from 1976 - 2008
SELECT joined.continent AS continent, COUNT(joined.continent) AS num_olympics_held
FROM (SELECT cc.city AS city, cc.continent AS continent, o.Year AS year
	  FROM city_country AS cc
	  LEFT JOIN olympics AS o
		  ON o.City = cc.city
	  GROUP BY cc.city, cc.continent, o.Year) AS joined
GROUP BY joined.continent;

