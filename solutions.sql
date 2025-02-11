USE sakila; 
-- How many copies of the film "Hunchback Impossible" exist in the inventory system?
SELECT 
    COUNT(*) AS copies_in_inventory
FROM 
    inventory i
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    f.title = 'Hunchback Impossible';

-- List all films whose length is longer than the average length of all films.
SELECT 
    title, length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);

-- Use subqueries to display all actors who appear in the film "Alone Trip".
SELECT 
    first_name, last_name
FROM 
    actor
WHERE 
    actor_id IN (
        SELECT 
            actor_id 
        FROM 
            film_actor 
        WHERE 
            film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip')
    );

-- Identify all movies categorized as family films.
SELECT 
    f.title
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';
    
-- Get the name and email from customers from Canada using subqueries.
SELECT 
    first_name, last_name, email
FROM 
    customer
WHERE 
    address_id IN (
        SELECT 
            address_id 
        FROM 
            address 
        WHERE 
            city_id IN (
                SELECT 
                    city_id 
                FROM 
                    city 
                WHERE 
                    country_id = (SELECT country_id FROM country WHERE country = 'Canada')
            )
    );

-- Get the name and email of customers from Canada using joins.
SELECT 
    c.first_name, c.last_name, c.email
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada';

-- Which are films starred by the most prolific actor?
SELECT 
    actor_id, COUNT(*) AS film_count
FROM 
    film_actor
GROUP BY 
    actor_id
ORDER BY 
    film_count DESC
LIMIT 1;

SELECT 
    title
FROM 
    film
WHERE 
    film_id IN (
        SELECT 
            film_id
        FROM 
            film_actor
        WHERE 
            actor_id = (SELECT actor_id FROM film_actor GROUP BY actor_id ORDER BY COUNT(*) DESC LIMIT 1)
    );

-- Films rented by the most profitable customer.
SELECT 
    customer_id, SUM(amount) AS total_spent
FROM 
    payment
GROUP BY 
    customer_id
ORDER BY 
    total_spent DESC
LIMIT 1;

SELECT 
    f.title
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    r.customer_id = (
        SELECT 
            customer_id 
        FROM 
            payment
        GROUP BY 
            customer_id
        ORDER BY 
            SUM(amount) DESC
        LIMIT 1
    );

-- Get the customer_id and the total_amount_spent of clients who spent more than the average total amount spent by all clients.

SELECT 
    customer_id, SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    total_amount_spent > (SELECT AVG(total_spent) FROM (SELECT SUM(amount) AS total_spent FROM payment GROUP BY customer_id) AS avg_spent);
