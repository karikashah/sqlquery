USE Sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name,  ' ', last_name) AS ' Actor Name'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "Joe";

-- 2b.  Find all actors whose last name contain the letters GEN
SELECT * 
FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order
SELECT * 
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id,  country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB
SELECT * from actor;

ALTER TABLE actor
ADD COLUMN description BLOB;

SELECT * from actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
SELECT * from actor;

ALTER TABLE actor
DROP COLUMN description;

SELECT * from actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(*)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(*) AS 'CommonLN'
FROM actor
GROUP BY last_name
HAVING CommonLN >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name="GROUCHO" AND last_name="WILLIAMS";

SELECT * FROM actor WHERE actor_id=172;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name="HARPO" AND last_name="WILLIAMS";

SELECT * FROM actor WHERE actor_id=172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE address; 

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff, address
WHERE staff.address_id = address.address_id;

-- mentioning JOIN keyword explicitely
SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
-- With this way the duration was 0.031 sec
SELECT s.first_name,s.last_name, SUM(p.amount) AS 'Total Amount'
FROM staff s, payment p
WHERE s.staff_id = p.staff_id AND MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;

-- mentioning JOIN keyword explicitely (Duration increased to 0.047 sec & added the condition for August 2005)
SELECT s.first_name,s.last_name, SUM(p.amount) AS 'Total Amount'
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id AND MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(fa.actor_id) 
FROM film f, film_actor fa
WHERE f.film_id = fa.film_id
GROUP BY f.title;

-- mentioning JOIN keyword explicitely (Again there is duration time diff)
SELECT f.title, COUNT(fa.actor_id) AS '# of Actors'
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(i.inventory_id)
FROM film f, inventory i 
WHERE f.film_id = i.film_id AND f.title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
SELECT c.first_name AS 'First Name', c.last_name AS 'Last Name',  SUM(p.amount) AS 'Total Amount Paid'
FROM payment p, customer c
WHERE p.customer_id = c.customer_id 
GROUP BY (p.customer_id)
ORDER BY (c.last_name);

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.title, l.name
FROM film f, language l
WHERE (f.language_id = l.language_id) AND (l.name= "English") AND (title LIKE "Q%" OR title LIKE "K%"); 

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT a.first_name, a.last_name
FROM actor a, film f, film_actor fa
WHERE (f.title = "Alone Trip") AND (f.film_id = fa.film_id) AND (fa.actor_id = a.actor_id) ;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.





