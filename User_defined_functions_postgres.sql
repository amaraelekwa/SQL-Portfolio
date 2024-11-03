/* Using the Sakila database, this query shows the value of inventory been held by the customer excluding data that has NULL values
using the user defined function called inventory_held_by_customer() */

--- Filter your query to only return records where the inventory_held_by_customer() function returns a non-null value.
-- Select the film title and inventory ids
SELECT 
	f.title, 
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
    inventory_held_by_customer(i.inventory_id) as held_by_cust
FROM film as f 
	INNER JOIN inventory AS i ON f.film_id = i.film_id 
WHERE
	-- Only include results where the held_by_cust is not null
    inventory_held_by_customer(i.inventory_id) IS NOT NULL;