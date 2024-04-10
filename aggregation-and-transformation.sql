-- You need to use SQL built-in functions to gain insights relating to the duration of movies:

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
use sakila ;
show tables;

select MAX(length) as max_duration, Min(length) as min_duration
 from film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
-- Hint: Look for floor and round functions.


select round(avg(length)) as mins,  round(avg(length)/60) as hours
from film;


-- You need to gain insights related to rental dates:
-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.

SELECT 
DATEDIFF(MAX(rental_date), MIN(rental_date)) 
AS age
FROM rental;


-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
select *, date_format(CONVERT(rental_date,date), '%M') AS 'Month' , date_format(CONVERT(rental_date,date), '%W') AS 'Day' 
from rental 
Order BY rental_date
Limit 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.

select *, date_format(CONVERT(rental_date,date), '%M') AS 'Month' , 
date_format(CONVERT(rental_date,date), '%W') AS 'Day',
CASE
WHEN date_format(CONVERT(rental_date,date), '%W') = 'Saturday' then 'weekend'
WHEN date_format(CONVERT(rental_date,date), '%W') = 'Sunday' then 'weekend'
ELSE 'working day'
END AS 'Day Type'from rental 
Order BY rental_date;


-- You need to ensure that customers can easily access information about the movie collection. 
-- To achieve this, retrieve the film titles and their rental duration. 
-- If any rental duration value is NULL, replace it with the string 'Not Available'. 
-- Sort the results of the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.

select title, IFNULL(rental_duration,'Not Available')
from film
Order By title asc;
 

-- Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. 
-- To achieve this, you need to retrieve the concatenated first and last names of customers, 
-- along with the first 3 characters of their email address, 
-- so that you can address them by their first name and use their email address to send personalized recommendations. 
-- The results should be ordered by last name in ascending order to make it easier to use the data.

select first_name, last_name, concat(first_name, " ", last_name) as 'Full name', left(email,3) as 'Short email' 
from customer 
order by last_name asc; 

-- Challenge 2
-- Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.

select Count(DISTINCT title)
 from film;

-- 1.2 The number of films for each rating.

select rating, Count(DISTINCT title) as count
from film
Group by rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.

select rating, Count(DISTINCT title) as count
from film
Group by rating
Order by count desc;

-- Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 


select rating, Count(DISTINCT title) as count, round(avg(length)) as duration
from film
Group by rating
Order by duration desc;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.

select rating, Count(DISTINCT title) as count, round(avg(length)) as duration
from film
Group by rating
Having duration > 119
Order by duration desc;

-- Bonus: determine which last names are not repeated in the table actor

select last_name, count(last_name) as count 
from actor
Group by last_name
Having count <2 
order by last_name;