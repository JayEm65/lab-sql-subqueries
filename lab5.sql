-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*)
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

-- Bonus 4: Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- Bonus 5: Retrieve the name and email of customers from Canada using both subqueries and joins.
-- Subquery
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE district = 'Ontario' AND city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- Using Joins
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- Bonus 6: Determine which films were starred by the most prolific actor in the Sakila database.
SELECT f.title
FROM film f
WHERE f.film_id IN (
    SELECT fa.film_id
    FROM film_actor fa
    WHERE fa.actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
);

-- Bonus 7: Find the films rented by the most profitable customer in the Sakila database.
SELECT f.title
FROM film f
WHERE f.film_id IN (
    SELECT p.film_id
    FROM payment p
    WHERE p.customer_id = (
        SELECT customer_id
        FROM payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1
    )
);

-- Bonus 8: Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS subquery
);
