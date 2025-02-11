-- Display for each store its store ID, city, and country
USE sakila;

DESCRIBE store;
DESCRIBE city;
DESCRIBE country;

SELECT 
    s.store_id, 
    c.city, 
    co.country
FROM 
    store s
JOIN 
    city c ON s.address_id = c.city_id
JOIN 
    country co ON c.country_id = co.country_id;

-- Display how much business, in dollars, each store brought in
SELECT 
    s.store_id, 
    SUM(p.amount) AS total_revenue
FROM 
    store s
JOIN 
    staff st ON s.store_id = st.store_id
JOIN 
    payment p ON st.staff_id = p.staff_id
GROUP BY 
    s.store_id;

-- What is the average running time of films by category?
SELECT 
    c.name AS category, 
    AVG(f.length) AS avg_running_time
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
GROUP BY 
    c.name;

-- Which film categories are longest?
SELECT 
    c.name AS category, 
    AVG(f.length) AS avg_running_time
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
GROUP BY 
    c.name
ORDER BY 
    avg_running_time DESC;

-- Display the most frequently rented movies in descending order
SELECT 
    f.title, 
    COUNT(r.rental_id) AS rental_count
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
GROUP BY 
    f.title
ORDER BY 
    rental_count DESC;

-- List the top five genres in gross revenue in descending order
SELECT 
    c.name AS category, 
    SUM(p.amount) AS gross_revenue
FROM 
    payment p
JOIN 
    rental r ON p.rental_id = r.rental_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film_category fc ON i.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
GROUP BY 
    c.name
ORDER BY 
    gross_revenue DESC
LIMIT 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
SELECT 
    f.title, 
    s.store_id, 
    CASE 
        WHEN i.inventory_id IS NOT NULL THEN 'Yes' 
        ELSE 'No' 
    END AS available_for_rent
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    store s ON i.store_id = s.store_id
WHERE 
    f.title = 'Academy Dinosaur' 
    AND s.store_id = 1;

