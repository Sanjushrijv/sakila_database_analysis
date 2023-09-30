-- top categories by revenue 
-- Least rented categories
-- movies rented for more days( from rental and film)
-- Films with lesser revenue in a month
-- Which actor's movie is being rented the most
-- Revenue based on spl features(from film)
-- Revenue based on rating


-- Slide 1 top categories by revenue 
SELECT c.name AS category_name, SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC; 

-- Slide 2 movies rented for more days
SELECT c.name AS category_name, f.title AS film_title, DATEDIFF(r.return_date, r.rental_date) AS rental_duration
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY category_name, rental_duration DESC;


-- Slide 3 Which actor's movie is being rented the most
SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(*) AS rental_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id, actor_name
ORDER BY rental_count DESC
LIMIT 5;



-- Slide 4 Revenue based on spl features(from film)
SELECT
    f.special_features,
    SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.special_features
ORDER BY total_revenue DESC;

-- Slide 5 Revenue based on rating
SELECT
    f.rating,
    SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_revenue DESC;


-- Slide 6 Which actors have been cast in the most films
SELECT
    a.actor_id,
    CONCAT( a.first_name, ' ', a.last_name) as Name,
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 10;


-- Slide 7 What are the peak rental hours or days?
SELECT
    CONCAT(
        CASE 
            WHEN HOUR(rental_date) = 0 THEN 12
            WHEN HOUR(rental_date) <= 12 THEN HOUR(rental_date)
            ELSE HOUR(rental_date) - 12
        END,
        CASE 
            WHEN HOUR(rental_date) < 12 THEN ' AM'
            ELSE ' PM'
        END,
        ', ',
        CASE DAYOFWEEK(rental_date)
            WHEN 1 THEN 'Sunday'
            WHEN 2 THEN 'Monday'
            WHEN 3 THEN 'Tuesday'
            WHEN 4 THEN 'Wednesday'
            WHEN 5 THEN 'Thursday'
            WHEN 6 THEN 'Friday'
            WHEN 7 THEN 'Saturday'
        END
    ) AS rental_time_day,
    COUNT(rental_id) AS rental_count
FROM rental
GROUP BY rental_time_day
ORDER BY rental_count DESC
LIMIT 10;


-- Slide 8 Category wise count of movies that have not been rented
SELECT c.name AS category_name, COUNT(*) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE DATEDIFF(r.return_date, r.rental_date) = 0
GROUP BY category_name
ORDER BY rental_count DESC;
