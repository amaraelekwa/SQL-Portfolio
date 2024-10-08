CREATE TABLE public.international_debt(
       country_name VARCHAR(255),
       country_code VARCHAR(10),
       indicator_name VARCHAR(255),
       indicator_code VARCHAR(255),
	   debt REAL
);

/* What is the number of distinct countries present in the database?*/
SELECT COUNT (DISTINCT country_name) AS total_distinct_countries
FROM international_debt;

/*What country has the highest amount of debt?*/
SELECT
   country_name, 
   SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC
LIMIT 1;

/* What country has the lowest amount of repayments?*/
SELECT country_name, 
       indicator_name, 
       MIN(debt) AS lowest_repayment
FROM international_debt
WHERE indicator_code = 'DT.AMT.DLXF.CD'
GROUP BY country_name, indicator_name
ORDER BY lowest_repayment
LIMIT 1;

/* What country has the highest GDP capital?*/
SELECT 
    international_debt.country_name,
    international_debt.indicator_name,
    MAX(economies.gdp_percapita) AS max_gdp
FROM international_debt
INNER JOIN economies ON international_debt.country_code = economies.code
GROUP BY 
    international_debt.country_name, 
    international_debt.indicator_name
ORDER BY 
    max_gdp ASC
LIMIT 1;

/* What country has the lowest income group, grouped by year?*/
SELECT DISTINCT
    economies.year,
    international_debt.country_name,
    MIN(economies.gdp_percapita) AS min_gdp,
    SUM(gross_savings) AS total_gross_savings,
    MIN(debt) AS lowest_repayment
FROM international_debt
INNER JOIN economies ON international_debt.country_code = economies.code
WHERE income_group = 'Low income'
GROUP BY 
    international_debt.country_name, 
    economies.year
ORDER BY 
    min_gdp DESC,
    economies.year ASC;