-- Active: 1722706024388@@127.0.0.1@5433@datacampDB
DROP TABLE public.cities_datacamp_dataset;
CREATE TABLE public.cities_datacamp_dataset(
       name VARCHAR(255),
       country_code VARCHAR(10),
       city_proper_pop BIGINT,
       metroarea_pop BIGINT,
       urbanarea_pop BIGINT
); 

DROP TABLE public.countries_datacamp_dataset;
CREATE TABLE public.countries_datacamp_dataset(
       code VARCHAR(255),
       country_name VARCHAR(255),
       continent VARCHAR(255),
       region VARCHAR(255),
       surface_area BIGINT,
	   indep_year INT,
       local_name VARCHAR(255),
       gov_form VARCHAR(255),
       capital VARCHAR(255),
       cap_long REAL,
       cap_lat REAL
); 

CREATE TABLE public.league (
      id INT,
      name VARCHAR(255),
      country_id INT
);


DROP TABLE public.currencies;
CREATE TABLE public.currencies(
       curr_id INT,
       code VARCHAR(10),
       basic_unit VARCHAR(255),
       curr_code VARCHAR(10),
       frac_unit VARCHAR(255),
	  frac_perbasic REAL
);  

DROP TABLE public.economies;
CREATE TABLE public.economies(
       econ_id INT,
       code VARCHAR(10),
       year INT,
	   income_group VARCHAR(255),
       gdp_percapita REAL,
       gross_savings REAL,
	   inflation_rate REAL,
	   total_investment REAL,
	   unemployment_rate REAL,
       exports REAL,
       imports REAL
);  

DROP TABLE public.populations;
CREATE TABLE public.populations(
       pop_id INT,
       country_code VARCHAR(10),
       year INT,
       life_expectancy REAL,
	   fertility_rate REAL,
       size BIGINT
);

DROP TABLE public.languages;
CREATE TABLE public.languages(
       lang_id INT,
       code VARCHAR(10),
       name VARCHAR(255),
	   percent REAL,
       official BOOLEAN
);  

CREATE TABLE public.economies2015 (
      code    VARCHAR(10),   
      year    INT,
      income_group VARCHAR(255),
      gross_savings REAL
);

CREATE TABLE public.economies2019 (
      code    VARCHAR(10),   
      year    INT,
      income_group VARCHAR(255),
      gross_savings REAL
);

SELECT 
     cities.name AS city, 
     countries.region AS region, 
     countries.country_name AS country
FROM cities
INNER JOIN countries ON cities.country_code = countries.code;

SELECT * 
FROM cities
-- Inner join to countries
INNER JOIN countries
-- Match on country codes
ON cities.country_code = countries.code;

SELECT 
     cities.name AS city, 
     countries.name AS country, 
     countries.region AS region
FROM cities
INNER JOIN countries ON cities.country_code = countries.code;

SELECT name,
       region,
       city_proper_pop,
       surface_area,
       gov_form
---- Not adding table names makes query unreadable
FROM cities
INNER JOIN countries ON cities.country_code = countries.code
INNER JOIN economies ON economies.code = countries.code
INNER JOIN populations ON populations.country_code = cities.country_code

SELECT 
     c.code AS country_code, 
     country_name, 
     year, 
     inflation_rate
 FROM countries AS c
 INNER JOIN economies AS e ON c.code = e.code;  

SELECT 
      c.country_name AS country, 
      l.name AS language, 
      official
 FROM countries AS c
 INNER JOIN languages AS l USING (code);       

SELECT cu.code AS currency_code, e.year AS year
FROM currencies AS cu
INNER JOIN economies AS e ON cu.code = e.code;

SELECT 
     cu.code AS currency_code, e.year AS year
 FROM currencies AS cu
 INNER JOIN economies AS e USING (code);

SELECT country_name, curr_id, basic_unit, surface_area
FROM currencies
INNER JOIN countries 
ON currencies.code = countries.code     

SELECT column_names FROM table1 INNER JOIN table2 ON table1.common_field = table2.common_field; otherwise use USING()
-- INNER join Logic

-- Select country and language names, aliased
SELECT c.country_name AS country,l.name AS language
-- From countries (aliased)
FROM countries AS c
-- Join to languages (aliased)
INNER JOIN languages AS l
-- Use code as the joining field with the USING keyword
USING(code);

-- Rearrange SELECT statement, keeping aliases
SELECT l.name AS language, c.country_name AS country
FROM countries AS c
INNER JOIN languages AS l USING(code)
-- Order the results by language
ORDER BY language;

SELECT c.country_name AS country, l.name AS language
FROM countries AS c
INNER JOIN languages AS l USING(code)
ORDER BY country;

SELECT country_name, year, fertility_rate
FROM populations AS p
-- Inner join countries and populations, aliased, on code
INNER JOIN countries AS c ON c.code = p.country_code

-- Select fields
SELECT country_name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p ON c.code = p.country_code
-- Join to economies (as e)
INNER JOIN economies AS e
-- Match on country code
ON c.code = e.code

SELECT 
    cities.name,
    countries.region,
    cities.city_proper_pop,
    countries.surface_area,
    countries.gov_form,
    currencies.curr_code,
    currencies.curr_id,
    economies.income_group,
    economies.year,
    languages.name,
    languages.code,
    languages.official
--- Learning to include table names in select query when joining
FROM cities
INNER JOIN countries ON cities.country_code = countries.code
INNER JOIN economies ON economies.code = countries.code
INNER JOIN languages ON languages.code = cities.country_code
INNER JOIN currencies ON currencies.code = countries.code;

SELECT country_name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e ON c.code = e.code
-- Add an additional joining condition such that you are also joining on year
AND e.year = p.year;

SELECT 
    c1. name AS city,
    code,
    c2. country_name AS country,
    region,
    city_proper_pop
FROM cities AS c1
-- Perform an inner join with cities as c1 and countries as c2 on country code
INNER JOIN countries AS c2 ON c1.country_code = c2.code
ORDER BY code DESC;

SELECT 
	c1.name AS city, 
    code, 
    c2.country_name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
-- Join right table (with alias)
LEFT JOIN countries AS c2 ON c1.country_code = c2.code
ORDER BY code DESC;

SELECT country_name, region, gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
-- Match on code fields
USING (code)
-- Filter for the year 2010
WHERE year = 2010;

-- Select region, and average gdp_percapita as avg_gdp
SELECT region,
       avg(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
-- Group by region
GROUP BY region;

SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC
-- Return only first 10 records
LIMIT 10;

SELECT country_name AS country, languages.name AS language, percent
FROM countries
RIGHT JOIN languages
USING(code)
ORDER BY language;

SELECT country_name AS country, languages.name AS language, percent
FROM countries
LEFT JOIN languages
USING(code)
ORDER BY language;

-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT countries.name AS country, languages.name AS language, percent
FROM countries
LEFT JOIN languages
USING(code)
ORDER BY language;

-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT countries.name AS country, languages.name AS language, percent
FROM languages
RIGHT JOIN countries
USING(code)
ORDER BY language;

--- ALL JOINS Practice
SELECT country_name AS country, code, region, basic_unit
 FROM countries
-- Join to currencies
 FULL JOIN currencies USING (code)
-- Where region is North America or name is null
 WHERE region = 'North America' 
    OR country_name IS NULL
 ORDER BY region;

SELECT country_name AS country, code, region, basic_unit
 FROM countries
-- Join to currencies
 LEFT JOIN currencies USING (code)
 WHERE region = 'North America' 
	OR country_name IS NULL
 ORDER BY region;

SELECT country_name AS country, code, region, basic_unit
 FROM countries
-- Join to currencies
 INNER JOIN currencies USING (code)
 WHERE region = 'North America' 
	OR country_name IS NULL
 ORDER BY region;

SELECT 
--Chaining FULL JOINs
	c1.country_name AS country, 
    region, 
    l.name AS language,
	basic_unit, 
    frac_unit
FROM countries as c1 
-- Full join with languages (alias as l)
FULL JOIN languages AS l USING (code)
-- Full join with currencies (alias as c2)
FULL JOIN currencies AS c2 USING (code) 
WHERE region LIKE 'M%esia';

SELECT country_name AS country, l.name AS language
-- Inner join countries as c with languages as l on code
FROM languages AS l
INNER JOIN countries AS c USING (code)
WHERE c.code IN ('PAK','IND')
	AND l.code in ('PAK','IND');

SELECT country_name AS country, l.name AS language
FROM countries AS c        
-- Perform a cross join to languages (alias as l)
CROSS JOIN languages AS l 
WHERE c.code in ('PAK','IND')
	AND l.code in ('PAK','IND');     

SELECT 
    c.country_name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
-- Join to populations (alias as p) using an appropriate join
INNER JOIN  populations AS p
ON c.code = p.country_code
-- Filter for only results in the year 2010
WHERE year = 2010
-- Sort by life_exp
ORDER BY life_exp ASC
-- Limit to five records
LIMIT 5;

SELECT p1.country_code, 
       p1.size AS size2010, 
       p2.size AS size2015
-- SELF JOINS
FROM populations AS p1       
-- Join populations as p1 to itself, alias as p2, on country code
INNER JOIN populations AS p2 ON p1.country_code = p2.country_code;

SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = 2010
-- Filter such that p1.year is always five years before p2.year
AND p1.year = p2.year - 5;

-- Select all fields from economies2015
SELECT *
FROM economies2015    
-- Set operation
UNION
-- Select all fields from economies2019
SELECT * 
FROM economies2019
ORDER BY code, year;


SELECT code, year
FROM economies
-- Query that determines all pairs of code and year from economies and populations, without duplicates
UNION 
SELECT country_code, year
FROM populations
ORDER BY code, year;

SELECT code, year
FROM economies
-- Set theory clause
UNION ALL
SELECT country_code, year
FROM populations
ORDER BY code, year;


SELECT name
FROM cities
-- Return all cities with the same name as a country
INTERSECT
SELECT country_name
FROM countries

SELECT name
FROM cities
-- Return all cities that do not have the same name as a country
EXCEPT
SELECT country_name
FROM countries
ORDER BY name;

SELECT DISTINCT name
FROM languages
-- Add syntax to use bracketed subquery below as a filter
WHERE code IN
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;

-- Select code and name of countries from Oceania
SELECT code, name
FROM countries 
WHERE continent = 'Oceania';

SELECT code, country_name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
  AND code NOT IN
    (SELECT code
    FROM currencies);

SELECT *
FROM populations
-- Filter for only those populations where life expectancy is 1.15 times higher than average
WHERE life_expectancy > 1.15 *
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015) 
    AND year = 2015;

---- Return the name, country_code and urbanarea_pop for all capital cities (not aliased).
 --Select relevant fields from cities table
 SELECT name, country_code, urbanarea_pop
 FROM cities
-- Filter using a subquery on the countries table
 WHERE name IN
     (SELECT capital
     FROM countries)
 ORDER BY urbanarea_pop DESC;     

 -- Find top nine countries with the most cities include country names as country, and count the cities in each country, aliased as cities_num.
SELECT countries.country_name AS country, count(*) AS cities_num
FROM countries
--Write a LEFT JOIN with countries on the left and the cities on the right, joining on country code.
LEFT JOIN cities 
ON countries.code = cities.country_code
--Sort by  country (ascending), limiting to the first nine records.
GROUP BY countries.country_name
-- Order by count of cities as cities_num
ORDER BY cities_num DESC
LIMIT 9;

SELECT countries.country_name AS country,
-- Subquery that provides the count of cities   
  (SELECT COUNT (*)
   FROM cities
   WHERE cities.country_code = countries.code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;

-- Select code, and language count as lang_num
SELECT code, COUNT(*) AS lang_num
FROM languages
GROUP BY code;

SELECT local_name, sub.lang_num
FROM countries,
  (SELECT code, COUNT(*) AS lang_num
  FROM languages
  GROUP BY code) AS sub
-- Where codes match
WHERE countries.code = sub.code
ORDER BY lang_num DESC;

-- Select relevant fields
SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code
   FROM countries
   WHERE(gov_form LIKE '%Monarchy%' OR gov_form LIKE '%Republic%'))
ORDER BY inflation_rate;

-- Select fields from cities
SELECT 
	name, 
    country_code, 
    city_proper_pop, 
    metroarea_pop,
    city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities
-- Use subquery to filter city name
WHERE name IN
  (SELECT capital
   FROM countries
   WHERE (continent = 'Europe'
   OR continent LIKE '%America'))
-- Add filter condition such that metroarea_pop does not have null values
AND metroarea_pop IS NOT NULL
-- Sort and limit the result
ORDER BY city_perc DESC
LIMIT 10;


