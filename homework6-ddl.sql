-- homework6-ddl.sql

-- task 1
-- store your drop table statements in this block
-- (skills: drop table)

drop table if exists wdi_country;

-- task 2
-- create local table of countries.  For this task, your creating your own copy
-- of the countries table, using the table that I already created.
-- You can directly access my table using "202310_hw6.wdi_country".
-- I'm providing you with a starting BUT INCORRECT statement to demonstrate the SYNTAX.
--
-- ALSO REMEMBER to leverage your knowledge from homework 5,
-- that is, the country table includes records for both countries and GROUPS of
-- countries (e.g., Arab World, etc.).  You need to FILTER OUT the records
-- that you don't need.
-- (skills: create table from another table)

drop table if exists wdi_country;
create table wdi_country as
SELECT
  *
FROM
  202310_hw6.wdi_country
WHERE
  region != ''
;

--select * from wdi_country limit 10;
-- task 3
-- create local wdi data table using 202310_hw6.wdi_data
-- (skills: create table)
drop table if exists wdi_data;
create table wdi_data as
SELECT
  *
FROM
  202310_hw6.wdi_data
WHERE
  1=1;

--select count(*) from wdi_data;
-- task 4
-- create local table of series info.  A series table contains information
-- about the data that you're using.
-- (using 202310_hw6.wdi_series)
-- (skills: create table)
drop table if exists wdi_series;
create table wdi_series as
SELECT
  *
FROM  
  202310_hw6.wdi_series
WHERE
  1=1;

--select count(*) from wdi_series;
-- task 5
-- (this task doesn't need to be completed until after task 12 or so in the DML file.)
-- Create a new table containing stacked data from WDI_DATA.
-- Each row should have four columns: country_code, indicator_code, year_code, value
-- (skills: create table with select, UNION ALL)

drop table if exists wdi_data_stacked;

create table wdi_data_stacked as
SELECT country_code, indicator_code, 1960 as year, yr1960 as value FROM wdi_data
union ALL
select country_code, indicator_code, 1965 as year, yr1965 as value FROM wdi_data
union ALL
select country_code, indicator_code, 1970 as year, yr1970 as value FROM wdi_data
union ALL
select country_code, indicator_code, 1975 as year, yr1975 as value FROM wdi_data
union ALL
select country_code, indicator_code, 1980 as year, yr1980 as value FROM wdi_data
union ALL
select country_code, indicator_code, 1985 as year, yr1985 as value FROM wdi_data
union ALL
select country_code, indicator_code, 1990 as year, yr1990 as value FROM wdi_data
union ALL
select country_code, indicator_code, 1995 as year, yr1995 as value FROM wdi_data
union ALL
select country_code, indicator_code, 2000 as year, yr2000 as value FROM wdi_data
union ALL
select country_code, indicator_code, 2005 as year, yr2005 as value FROM wdi_data
union ALL
select country_code, indicator_code, 2010 as year, yr2010 as value FROM wdi_data
union ALL
select country_code, indicator_code, 2015 as year, yr2015 as value FROM wdi_data
union ALL
select country_code, indicator_code, 2020 as year, yr2020 as value FROM wdi_data
;

--select count(*) from wdi_data_stacked;
