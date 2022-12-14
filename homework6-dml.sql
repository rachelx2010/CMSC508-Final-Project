-- homework6-ddl.sql

-- task 1
-- How many records are in your local WDI_COUNTRY table?
-- (skills: select, aggregate)
select count(*) from wdi_country;

-- task 2
-- How many records are in your local WDI_DATA table?
-- (skills: select, aggregate)
select count(*) from wdi_data;

-- task 3
-- How many records are in your local WDI_SERIES table?
-- (skills: select, aggregate)
select count(*) from wdi_series;

-- task 4
-- Let's explore the WDI_DATA table first.  What do the first 10 records look like?
-- (skills: select, limit)

SELECT * FROM wdi_data limit 10;

-- task 5
-- What are the columns?
-- (skills: describe table)

describe wdi_data;

-- task 6
-- It appears that the WDI_DATA table contains one record per country per some sort of data value 
-- over time.  LOTS of time.
-- But first, what are the different "indicator_codes" in WDI_DATA?

select distinct indicator_code from wdi_data order by 1;
-- task 7
-- OK, but what the heck are these datum?  The WDI_SERIES data offer "meta-data" that describes
-- the "data" in the WDI_DATA file.  WRITE a query that provides descriptions for the indicators
-- in the WDI_DATA table using information from the WDI_SERIES table.
-- Your result should include 3 columns (series code, indicator name and long definition)
-- (you need to determine which columns join the two tables, and select a subset of wdi_series)
-- (skills: select, subquery)

select 
    series_code,
    indicator_name,
    long_definition
from 
    wdi_series 
WHERE
    series_code in (select distinct indicator_code from wdi_data);

-- task 8
-- INTERESTING! We've got three different types of data in the WDI data table.  We'll need to 
-- exercise care when we start adding stuff up, we don't want to mix and match the wrong data.
-- ARE YOU READY?
--
-- What was the world population in 1960 and in 2021?
--
-- (your result should have 3 columns, the indicator, the population in 1960 and the population in 2021).
-- (keeping it simple, there are no joins necessary: use a subquery in the WHERE)
-- (your result should also use the FORMAT function to add commas to the resulting values,
-- and order by indicator_code.)
-- (skills: select, aggregate, subquery)
--
select
    indicator_code,
    format(sum(yr1960),0) as yr1960,
    format(sum(yr2021),0) as yr2021
FROM
    wdi_data
WHERE
    1=1
    and indicator_code = 'SP.POP.TOTL'
    and country_code in (select distinct country_code from wdi_country)
;

-- task 9
-- That was fun! let's see what the other values turned out to be.
-- Rerun the last query, including the other indicators.
-- (your result should have 3 columns, the indicator, the population in 1960 and the population in 2021).
-- (keeping it simple, there are no joins necessary: use a subquery in the WHERE)
-- (skills: select, aggregate, subquery)
--

select
    indicator_code,
    format(sum(yr1960),0) as yr1960,
    format(sum(yr2021),0) as yr2021
FROM
    wdi_data
WHERE
    1=1
--    and indicator_code = 'SP.POP.TOTL'
    and country_code in (select distinct country_code from wdi_country)
GROUP BY
    indicator_code
ORDER BY
    1
;


-- task 10
-- Hummhhh... Looks like there are zeros for one of the indicators for the years that we're
-- investigating.  What is the first year and the last year that CO2 data are available,
-- and what are the specific values accumulated?
-- (your result should consist of one row and three columns, one column for the indicator and two for the values
-- returned for first non-zero years.)
-- (skills: select, aggregation, subquery)

select
    indicator_code,
    FORMAT(sum(yr1990), '##,###,###') as yr1990,
    FORMAT(sum(yr2019), '##,###,###') as yr2019
FROM
    wdi_data
WHERE
    1=1
    and indicator_code = 'EN.ATM.CO2E.KT'
    and country_code in (select distinct country_code from wdi_country)
GROUP BY
    indicator_code
ORDER BY
    1
;

--SELECT * from wdi_data where indicator_code = 'EN.ATM.CO2E.KT' limit 10;

-- task 11
-- What is the percentage of females in the world in 1960 and in 2020?
-- (your result should consist of one row and three columns, with description, % in 1960 and % in 2020)
-- (the description should be exactly: "Percent female")
-- (numeric values should show 2 places past the decimal AND include a % sign,  e.g., 33.33%  or 59.15%)
-- (skills: select, aggregate, subquery/with, format, concat)

with total_cte as (
select
    indicator_code,
    sum(yr1960) as yr1960,
    sum(yr2020) as yr2020
FROM
    wdi_data
WHERE
    1=1
    and indicator_code in ('SP.POP.TOTL')
    and country_code in (select distinct country_code from wdi_country)
GROUP BY
    indicator_code
),
female_cte as (
select 
    indicator_code,
    sum(yr1960) as yr1960,
    sum(yr2020) as yr2020
FROM
    wdi_data
WHERE
    1=1
    and indicator_code in ('SP.POP.TOTL.FE.IN')
    and country_code in (select distinct country_code from wdi_country)
GROUP BY
    indicator_code
)
select 
    'Percent female',
    concat(format(100.0*female_cte.yr1960/total_cte.yr1960,2),'%') as pct_1960,
    concat(format(100.0*female_cte.yr2020/total_cte.yr2020,2),'%') as pct_2020
from 
    total_cte,
    female_cte
;

-- task 12
-- WOW! that was difficult! Seems like a lot of work, forced to hardcode years and values
-- just to calculate percentages for these data.  IS THERE A SIMPLER WAY?
--
-- When doing data analysis, how your data are stacked make a difference.  Our lives would be
-- much simpler if we rearranged the data with indicators in the columns and years in the rows.
--
-- BUT HOW??  
--
-- The table WDI_DATA is currently stored in what is call a "wide format".  The data can
-- be transformed into a more manageble format - a "stacked format" that will let us pivot
-- things around.
--
-- Jump back to the DDL file and create us a new table with the data stacked vertically.
--
-- OK, back.  How many rows are in your stacked table?

SELECT count(*) from wdi_data_stacked;

-- task 13
-- Present table with number of records in each year_code group.

SELECT
    year,
    count(*)
FROM
    wdi_data_stacked
GROUP BY    
    year
ORDER BY
    1
;


-- task 14
-- Phew. Glad that's over!  Let's recalculate percentage female for the new table of stacked data.
-- (your result should have four columns: year, % female, pop female and total pop; 
-- one record per year in the wdi_data_stacked table.  Don't forget to use ONLY country data from the WDI!)
-- (skills: select, aggregate, WITH/subquery, FORMAT)
--

with pivot_cte as (
SELECT
    year,
--    indicator_code,
--    sum(VALUE) as value,
    sum(case when indicator_code = 'SP.POP.TOTL' then value else 0 end ) as pop_total,
    sum(case when indicator_code = 'SP.POP.TOTL.FE.IN' then value else 0 end ) as pop_female
from
    wdi_data_stacked
WHERE
    indicator_code in ('SP.POP.TOTL', 'SP.POP.TOTL.FE.IN')
    and country_code in (select distinct country_code from wdi_country)
GROUP BY
    year 
--    indicator_code
)
select 
    year,
    concat(format(100.0* pop_female / pop_total,2),'%') as pct_female,
    format(pop_female,0),
    format(pop_total,0)
from 
    pivot_cte
ORDER BY
    YEAR
;


-- task 15
-- Armed with a stacked data file, the table of world indicators is our oyster!
-- Prepare a table comparing total population from 1990 to 2020 (columns) by region.
--Hint: this task wants 4 columns, the region, that region's 1990 population, 
--that region's 2020 population, and the difference
--and the difference between those two populations for each region.
--** take the working query we have in task #14 and comparing columns (1990-2020)

with pivot_cte as (
SELECT
--    a.country_code,
--    indicator_code,
    region,
    sum(case when indicator_code = 'SP.POP.TOTL' and year = 1990 then value else 0 end ) as pop_total_1990,
--    sum (case when indicator_code = 'SP.POP.TOTL.FE.IN' and year = 1990 then value else 0 end ) as pop_female_1990,
    sum(case when indicator_code = 'SP.POP.TOTL' and year = 2020 then value else 0 end ) as pop_total_2020
from
    wdi_data_stacked a 
    inner join wdi_country b on (a.country_code=b.country_code)
WHERE
    indicator_code in ('SP.POP.TOTL')
GROUP BY
--    year,
--    a.country_code,
    region
)
select 
    region,
    format (pop_total_1990,0) as pop_1990,
    format(pop_total_2020,0) as pop_2020,
    format(pop_total_2020 - pop_total_1990,0) as pop_difference
from 
    pivot_cte 
ORDER BY
    region ASC
;

-- task 16
-- Prepare a table comparing pct female from 1990 to 2020 (columns) by region.
--Hint: wants 3 columns, the region, 
--percentage of females in 1960 in that region, 
--and percentage of females in 2020 in that region.

with pivot_cte as (
SELECT
--    a.country_code,
--    indicator_code,
    region,
    sum(case when indicator_code = 'SP.POP.TOTL' and year = 1990 then value else 0 end ) as pop_total_1990,
    sum(case when indicator_code = 'SP.POP.TOTL.FE.IN' and year = 1990 then value else 0 end ) as pop_female_1990,
    sum(case when indicator_code = 'SP.POP.TOTL' and year = 2020 then value else 0 end ) as pop_total_2020,
    sum(case when indicator_code = 'SP.POP.TOTL.FE.IN' and year = 2020 then value else 0 end ) as pop_female_2020
from
    wdi_data_stacked a 
    inner join wdi_country b on (a.country_code=b.country_code)
WHERE
    indicator_code in ('SP.POP.TOTL', 'SP.POP.TOTL.FE.IN')
GROUP BY
--    year,
--    a.country_code,
    region
)
select 
    region,
    concat(format (100.0 * pop_female_1990/pop_total_1990,2),'%') as pct_1990,
    concat(format(100.0* pop_female_2020/pop_total_2020,2),'%') as pct_2020
from 
    pivot_cte
ORDER BY
    region ASC
;
