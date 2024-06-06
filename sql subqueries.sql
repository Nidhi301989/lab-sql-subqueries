-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;
SELECT COUNT(inventory.inventory_id) AS number_of_copies
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';

-- 2.List all films whose length is longer than the average of all the films.?
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN ( select * from (
    SELECT actor_id 
    FROM film_actor join film on film_actor.film_id = film.film_id
	WHERE title = 'Alone Trip' ) as db
);

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 6.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT c.first_name, c.last_name, c.email
FROM customer AS c
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS ci ON a.city_id = ci.city_id
WHERE ci.country_id = (
    SELECT country_id
    FROM country
    WHERE country = 'Canada'
);

-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT f.title
FROM film AS f
JOIN film_actor AS fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);

-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT film.title
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.customer_id = (
        SELECT customer_id
        FROM payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1
    );

8.Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id,
    total_amount_spent
FROM (SELECT 
        customer_id,
        SUM(amount) AS total_amount_spent
     FROM ayment
     GROUP BY customer_id) AS customer_totals
WHERE 
    total_amount_spent > (
        SELECT 
            AVG(total_amount_spent) AS average_spent
        FROM 
            (SELECT 
                customer_id,
                SUM(amount) AS total_amount_spent
             FROM 
                payment
             GROUP BY 
                customer_id) AS customer_totals
    );













































































































