USE Sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
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
SHOW CREATE TABLE address;

DESCRIBE address; -- Represents the same inform as show create table BUT in a fancier & better readble way

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address   -- Personally I like this way much better as it is easy to write & read BUT have re-written in the way asked.
FROM staff, address
WHERE staff.address_id = address.address_id;

	-- mentioning JOIN keyword explicitely --- THIS IS WHAT CAM NEEDS.
	SELECT s.first_name, s.last_name, a.address
	FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name,s.last_name, SUM(p.amount) AS 'Total Amount' -- Personally I like this way much better as it is easy to write & read BUT have re-written in the way asked.
FROM staff s, payment p
WHERE s.staff_id = p.staff_id AND MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;

	-- mentioning JOIN keyword explicitely
	SELECT s.first_name,s.last_name, SUM(p.amount) AS 'Total Amount'
	FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id AND MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005
	GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(fa.actor_id) 
FROM film f, film_actor fa
WHERE f.film_id = fa.film_id
GROUP BY f.title;

	-- mentioning JOIN keyword explicitely
	SELECT f.title, COUNT(fa.actor_id) AS '# of Actors'
	FROM film f
	INNER JOIN film_actor fa
	ON f.film_id = fa.film_id
	GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(i.inventory_id) AS Count
FROM film f, inventory i 
WHERE f.film_id = i.film_id AND f.title = "Hunchback Impossible";

	-- mentioning JOIN keyword explicitely
    SELECT title, COUNT(inventory_id) AS Count
	FROM film f
	INNER JOIN inventory i 
	ON f.film_id = i.film_id
	WHERE title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
SELECT c.last_name AS 'Last Name', c.first_name AS 'First Name',  SUM(p.amount) AS 'Total Amount Paid'
FROM payment p, customer c
WHERE p.customer_id = c.customer_id 
GROUP BY (p.customer_id)
ORDER BY (c.last_name);

	-- mentioning JOIN keyword explicitely
    SELECT c.last_name AS 'Last Name', c.first_name AS 'First Name',  SUM(p.amount) AS 'Total Amount Paid'
	FROM payment p
	INNER JOIN customer c
	ON p.customer_id = c.customer_id
	GROUP BY p.customer_id
	ORDER BY last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.title AS Title
FROM film f, language l
WHERE (f.language_id = l.language_id) AND (l.name= "English") AND (f.title LIKE "Q%" OR f.title LIKE "K%"); 

	-- Using SubQueries explicitely
    SELECT f.title AS Title
    FROM film f
	WHERE f.language_id in
		(SELECT l.language_id 
		FROM language l
		WHERE l.name = "English" )
	AND (f.title LIKE "Q%") OR (f.title LIKE "K%");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT a.first_name AS 'First Name', a.last_name AS 'Last Name'
FROM actor a, film f, film_actor fa
WHERE (f.title = "Alone Trip") AND (f.film_id = fa.film_id) AND (fa.actor_id = a.actor_id) ;

	-- Using SubQueries explicitely
    SELECT a.first_name AS 'First Name', a.last_name AS 'Last Name'
	FROM actor a
	WHERE a.actor_id in
		(SELECT fa.actor_id 
        FROM film_actor fa
		WHERE fa.film_id in 
			(SELECT f.film_id 
            FROM film f
			WHERE f.title = "Alone Trip"));
            
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.country, cu.last_name, cu.first_name, cu.email
FROM country c, customer cu
WHERE c.country_id = cu.customer_id AND c.country = 'Canada';

    -- mentioning JOIN keyword explicitely
    SELECT c.country, cu.last_name, cu.first_name, cu.email
	FROM country c
	LEFT JOIN customer cu
	ON c.country_id = cu.customer_id
	WHERE c.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
-- Using Subqueries
SELECT title, description
FROM film
WHERE film_id IN
	(SELECT film_id
	FROM film_category
	WHERE category_id IN
		(SELECT category_id 
		FROM category
		WHERE name = "Family"));

	-- Using JOIN
	SELECT title, description 
	FROM film f
	JOIN film_category fc ON (f.film_id = fc.film_id)
	JOIN category c ON (fc.category_id = c.category_id AND c.name = "Family");

-- 7e. Display the most frequently rented movies in descending order.
SELECT title AS Title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id = i.film_id)
JOIN rental r ON (i.inventory_id = r.inventory_id)
GROUP BY title 
ORDER BY Count_of_Rented_Movies DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) AS 'Business in $'
FROM payment p
JOIN staff s ON (p.staff_id = s.staff_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country
FROM store s, address a, city c, country co
WHERE s.address_id = a.address_id AND a.city_id = c.city_id AND c.country_id = co.country_id;

	-- Using JOINS
    SELECT s.store_id, c.city, co.country
	FROM store s
	JOIN address a ON (s.address_id = a.address_id)
    JOIN city c ON (a.city_id = c.city_id)
    JOIN country co ON (c.country_id = co.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue'
FROM category c, film_category fc, inventory i, rental r, payment p
WHERE c.category_id = fc.category_id AND fc.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
GROUP BY Genre
ORDER BY 'Gross Revenue' DESC LIMIT 5;

	-- Using JOINS
    SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue' 
	FROM category c
	JOIN film_category fc ON (c.category_id = fc.category_id)
	JOIN inventory i ON (fc.film_id = i.film_id)
	JOIN rental r ON (i.inventory_id = r.inventory_id)
	JOIN payment p ON (r.rental_id = p.rental_id)
	GROUP BY c.name ORDER BY 'Gross Revenue' LIMIT 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

-- 8b. How would you display the view that you created in 8a?

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.





