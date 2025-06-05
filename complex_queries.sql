----------------Project--------------------
-------------------------------------------

-------------- Question 1 ----------------
--     Topic: DISTINCT
-- Task: Create a list of all the different (distinct) replacement costs of the films.
-- Question: What's the lowest replacement cost?
-- 9.99

SELECT 
    DISTINCT replacement_cost 
FROM film
ORDER BY replacement_cost ASC
LIMIT 1;

-------------- Question 2 ----------------
-- Topic: CASE + GROUP BY
-- Task: Write a query that gives an overview of how many films have replacements costs in the following cost ranges
-- low: 9.99 - 19.99
-- medium: 20.00 - 24.99
-- high: 25.00 - 29.99
-- Question: How many films have a replacement cost in the "low" group?
-- 514

SELECT
    CASE
        WHEN replacement_cost <= 19.99 THEN 'low'
        WHEN replacement_cost <= 24.99 THEN 'medium'
        ELSE 'high'
    END AS cost_range,
    COUNT(*)
FROM film
GROUP BY cost_range;

-------------- Question 3 ----------------
-- Topic: JOIN
-- Task: Create a list of the film titles including their title, 
-- length, and category name ordered descendingly by length. 
-- Filter the results to only the movies in the category 'Drama' or 'Sports'.

-- Question: In which category is the longest film and how long is it?
-- Sports, 184

SELECT 
    title,
    length,
    category.name AS category
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name IN ('Drama', 'Sports')
ORDER BY length DESC;

-------------- Question 4 ----------------
-- Topic: JOIN & GROUP BY
-- Task: Create an overview of how many movies (titles) there are in each category (name).

-- Question: Which category (name) is the most common among the films?
-- Sports, 74

SELECT 
    category.name AS category,
    COUNT(title)
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY COUNT(title) DESC;

-------------- Question 5 ----------------
-- Topic: JOIN & GROUP BY
-- Task: Create an overview of the actors' first and last names and in how many movies they appear in.

-- Question: Which actor is part of most movies??
-- SUSAN FAVIS 54

SELECT 
    first_name,
    last_name,
    COUNT(fa.film_id) 
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY first_name, last_name
ORDER BY COUNT(fa.film_id) DESC;

-------------- Question 6 ----------------
-- Topic: LEFT JOIN & FILTERING
-- Task: Create an overview of the addresses that are not associated to any customer.

-- Question: How many addresses are that?
-- 4

SELECT 
    a.*
FROM address a
LEFT JOIN customer c ON a.address_id = c.address_id
WHERE customer_id is null;

-------------- Question 7 ----------------
-- Topic: JOIN & GROUP BY

-- Task: Create the overview of the sales to determine the from which city 
-- (we are interested in the city in which the customer lives, not where the store is) most sales occur.

-- Question: What city is that and how much is the amount?
-- Cape Coral 221.55 (misleading, max money, not number of sales!)

SELECT
    ci.city,
    -- count(payment_id),
    SUM(amount)
FROM payment p
JOIN customer c ON c.customer_id = p.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON ci.city_id = a.city_id
GROUP BY ci.city
ORDER BY SUM(amount) DESC;


-------------- Question 8 ----------------
-- Topic: JOIN & GROUP BY
-- Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".

-- Question: Which country, city has the least sales?
-- United States, Tallahassee	50.85

SELECT
    co.country || ', ' || ci.city AS country_city,
    SUM(amount) AS revenue
FROM
    payment p
    JOIN customer cu ON cu.customer_id = p.customer_id
    JOIN address a ON a.address_id = cu.address_id
    JOIN city ci ON ci.city_id = a.city_id
    JOIN country co ON co.country_id = ci.country_id
GROUP BY country_city
ORDER BY revenue ASC;

-------------- Question 9 ----------------
-- Topic: Uncorrelated subquery
-- Task: Create a list with the average of the sales amount each staff_id has per customer.

-- Question: Which staff_id makes on average more revenue per customer?
-- staff_id 2, 56.64

SELECT 
    staff_id,
    ROUND(AVG(total), 2) AS revenue_per_customer
FROM (SELECT staff_id, customer_id, sum(amount) AS total
    FROM payment
    GROUP BY staff_id, customer_id)
GROUP BY staff_id
ORDER BY revenue_per_customer DESC;

-------------- Question 10 ----------------
-- Topic: EXTRACT + Uncorrelated subquery
-- Task: Create a query that shows average daily revenue of all Sundays.

-- Question: What is the daily average revenue of all Sundays?
-- 1410.65

SELECT
    ROUND(AVG(daily_sum), 2) AS sundarys_avg_revenue
FROM (SELECT SUM(amount) AS daily_sum, date(payment_date) AS date
    FROM payment
    WHERE EXTRACT(DOW from date(payment_date)) = 0
    GROUP BY date);

-------------- Question 11 ----------------
-- Topic: Correlated subquery
-- Task: Create a list of movies - with their length and their 
-- replacement cost - that are longer than the average length in each replacement cost group.

-- Question: Which two movies are the shortest on that list and how long are they?
-- CELEBRITY HORN, SEATTLE EXPECATIONS; 110

SELECT
    title,
    length,
    replacement_cost
FROM film f1
WHERE f1.length > (SELECT AVG(length)
                            FROM film f2
                            WHERE f1.replacement_cost = f2.replacement_cost)
ORDER BY length ASC;

-------------- Question 12 ----------------
-- Topic: Uncorrelated subquery

-- Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.

-- Example:
-- If there are two customers in "District 1" where one customer has a total (lifetime) spent of $1000 
-- and the second customer has a total spent of $2000 then the "average customer lifetime spent" in this district is $1500.
-- So, first, you need to calculate the total per customer and then the average of these totals per district.

-- Question: Which district has the highest average customer lifetime value?
-- Saint-Denis	216.54

SELECT
    district,
    ROUND(AVG(customer_total), 2) as avg_customer_value
FROM 
    (SELECT customer_id, SUM(amount) AS customer_total
        FROM payment
        GROUP BY customer_id) p
    JOIN customer c ON p.customer_id = c.customer_id
    JOIN address a ON a.address_id = c.address_id
GROUP BY district
ORDER BY avg_customer_value DESC;


-------------- Question 13 ----------------
-- Topic: Correlated query
-- Task: Create a list that shows all payments including the 
-- payment_id, amount, and the film category (name) plus the total amount that was made in this category. 
-- Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.

-- Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?
-- total revenue for 'Action': 4375.85; lowest payment_id in 'Action'; 16055 

SELECT 
    payment_id,
    amount,
    c1.name AS film_category,
    (
        SELECT SUM(amount)
        FROM payment p2
        INNER JOIN rental r2 ON p2.rental_id = r2.rental_id
        INNER JOIN inventory i2 ON i2.inventory_id = r2.inventory_id
        INNER JOIN film_category fc2 ON fc2.film_id = i2.film_id
        INNER JOIN category c2 ON c2.category_id = fc2.category_id
        WHERE c2.name = c1.name
    ) AS total_category_amount
FROM
    payment p1
    INNER JOIN rental r1 ON p1.rental_id = r1.rental_id
    INNER JOIN inventory i1 ON i1.inventory_id = r1.inventory_id
    INNER JOIN film_category fc1 ON fc1.film_id = i1.film_id
    INNER JOIN category c1 ON c1.category_id = fc1.category_id
ORDER BY film_category ASC, payment_id ASC;

-- Better performance: calculates the talbe only once, not for each row!

WITH category_totals AS (
     SELECT 
         c.name AS film_category,
         SUM(p.amount) AS total_category_amount
     FROM payment p
     INNER JOIN rental r ON p.rental_id = r.rental_id
     INNER JOIN inventory i ON i.inventory_id = r.inventory_id
     INNER JOIN film_category fc ON fc.film_id = i.film_id
     INNER JOIN category c ON c.category_id = fc.category_id
     GROUP BY c.name
 )
 SELECT 
     p1.payment_id,
     p1.amount,
     c1.name AS film_category,
     ct.total_category_amount
 FROM
     payment p1
      INNER JOIN rental r1 ON p1.rental_id = r1.rental_id
     INNER JOIN inventory i1 ON i1.inventory_id = r1.inventory_id
     INNER JOIN film_category fc1 ON fc1.film_id = i1.film_id
     INNER JOIN category c1 ON c1.category_id = fc1.category_id
     INNER JOIN category_totals ct ON c1.name = ct.film_category
 ORDER BY film_category ASC, payment_id ASC;

-------------- Question 14 ----------------
-- Topic: Correlated and uncorrelated subqueries (nested)
-- Task: Create a list with the top overall revenue of a film title (sum of amount per title) for each category (name).

-- Question: Which is the top-performing film in the animation category?

SELECT
    title,
    name,
    SUM(amount) AS total
FROM payment p
    LEFT JOIN rental r ON r.rental_id = p.rental_id
    LEFT JOIN inventory i ON i.inventory_id = r.inventory_id
    LEFT JOIN film f ON f.film_id = i.film_id
    LEFT JOIN film_category fc ON fc.film_id = f.film_id
    LEFT JOIN category c ON c.category_id = fc.category_id
GROUP BY name, title
HAVING SUM(amount) = (
    SELECT MAX(total)
    FROM (
        SELECT
            title,
            name,
            SUM(amount) AS total
        FROM payment p
            LEFT JOIN rental r ON r.rental_id = p.rental_id
            LEFT JOIN inventory i ON i.inventory_id = r.inventory_id
            LEFT JOIN film f ON f.film_id = i.film_id
            LEFT JOIN film_category fc ON fc.film_id = f.film_id
            LEFT JOIN category c2 ON c2.category_id = fc.category_id
        GROUP BY name, title
        HAVING name = c.name
    ) sub
)
