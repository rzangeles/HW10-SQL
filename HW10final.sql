#HW10 - SQL Scripts

#1a. Display the first and last names of all actors from the table actor.

USE sakila;

SELECT first_name, last_name FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

# Remove column actor_name wen no longer needed
ALTER TABLE actor

	DROP Actor_name;

ALTER TABLE actor

	ADD Actor_Name VARCHAR(50);
    
SET SQL_SAFE_UPDATES = 0;

	UPDATE actor

		SET Actor_Name = CONCAT(first_name," ", last_name);

	UPDATE actor

		SET Actor_Name = UPPER(Actor_Name);

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM actor

		WHERE first_name = "Joe";
        
#2b. Find all actors whose last name contain the letters GEN:

SELECT * FROM actor
		
        WHERE last_name LIKE "%GEN%";
        
#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT * FROM actor

	WHERE last_name LIKE "%LI%"
    
    ORDER BY last_name, first_name ASC;
    
#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT * FROM country;

SELECT country_id, country FROM country

	WHERE country IN ("Afghanistan", "Bangladesh", "China");
    
    
#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

SELECT * FROM actor;

ALTER TABLE actor

	ADD middle_name VARCHAR(50)
    AFTER first_name;
    
SELECT * FROM actor;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.

ALTER TABLE actor

	MODIFY COLUMN middle_name blob;
    
SELECT * FROM actor;

#3c. Now delete the middle_name column.

ALTER TABLE actor

	DROP middle_name;

SELECT * FROM actor;

#4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, count(last_name) AS Last_Name_Count FROM actor GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT * FROM actor;

SELECT last_name, count(last_name) AS Last_Name_Count

	FROM actor
        
    GROUP BY last_name
    
    HAVING count(last_name) >=2;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

#updated code

UPDATE actor

	SET first_name = "HARPO"
    
	WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

SELECT * FROM actor

	WHERE first_name = "HARPO" AND last_name = "WILLIAMS";
	        
#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor

	SET first_name = "GROUCHO"
    
    WHERE actor_id = 172;
    
SELECT * FROM actor

		WHERE actor_id = 172;

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SELECT * from address;
#reference the tables from address table

USE sakila;

CREATE table address(

		address_id INT(10) AUTO_INCREMENT NOT NULL,
		address VARCHAR(255) NOT NULL,
        address2 VARCHAR(255),
        district VARCHAR(255),
        city_id VARCHAR(50),
        postal_code INT(10),
        phone INT(15),
        location blob,
        last_update TIMESTAMP,
        primary key(address_id)
        );        

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT * FROM staff;

SELECT * FROM address;

SELECT staff.first_name, staff.last_name, address.address
	
	FROM staff INNER JOIN address
    
	ON staff.address_id = address.address_id;
    
#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT * FROM staff;

SELECT * FROM payment;
    
SELECT staff.first_name, staff.last_name,

	(SELECT SUM(amount) FROM payment
	
	WHERE staff.staff_id = payment.staff_id AND payment.payment_date LIKE '2005-08%')
    
FROM staff;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT * FROM film;

SELECT * FROM film_actor;
#actor_id shows the actors on the film_id

SELECT film.title, 
	(SELECT COUNT(actor_id) FROM film_actor
    
    WHERE film.film_id = film_actor.film_id)
    
    FROM film INNER JOIN film_actor;
    

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT * FROM inventory;
#inventory table has film_id, use count of inventory_id

SELECT count(inventory_id) FROM inventory WHERE film_id IN
    
		(SELECT film_id FROM film
        
			WHERE title = "Hunchback Impossible");

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:    

SELECT * FROM payment;
#this table has customer_id and amount

SELECT * FROM customer;
#this table has customer_id and last_name

SELECT customer.last_name, SUM(amount) AS customer_payment

	FROM payment
    
    JOIN customer ON (payment.customer_id = customer.customer_id)
    
    GROUP BY customer.last_name ORDER BY customer.last_name ASC;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters 
#K and Q whose language is English.

SELECT * FROM film;
#this table has title, language_id 

SELECT * FROM language;
#this table has language_id and name

SELECT title FROM film 

	WHERE (title LIKE 'K%' OR title LIKE 'Q%') AND language_id IN

		(SELECT language_id FROM language
        
        WHERE name = 'English');

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT * FROM film;
#this table has film_id and title

SELECT * FROM actor;
#this table has actor_id, first_name and last_name

SELECT * FROM film_actor;
#this table has actor_id and film_id

SELECT first_name, last_name FROM actor

	WHERE actor_id IN
    
    (SELECT actor_id FROM film_actor
    
		WHERE film_id IN
        
		(SELECT film_ID FROM film
        
			WHERE title = 'Alone Trip')
            
	);
    
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all 
#Canadian customers. Use joins to retrieve this information.

SELECT * FROM customer;
#this table has first_name, last_name, email, and address_id

SELECT * FROM address;
#this table has address_id, district, and city_id

SELECT * FROM city;
#this table has city_id and country_id

SELECT * FROM country;
#this table has country_id and country

SELECT c.first_name, c.last_name, c.email

FROM customer c
	
    JOIN address a
    
		USING (address_id) 
        
			JOIN city cy
            
				USING (city_id)
                
					JOIN country ctry
                    
						USING (country_id)
                        
							WHERE country = 'Canada';
					
#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

SELECT * FROM film;
#this table has title and film_id

SELECT * FROM film_category;
#this table has film_id and category_id

SELECT * FROM category;
#this table has category_id and name (Family)

SELECT title FROM film 

	WHERE film_id IN
    
    (SELECT film_id FROM film_category
    
		WHERE category_id IN
        
        (SELECT category_id FROM category
        
			WHERE name = 'Family'
		)
	);
    
#7e. Display the most frequently rented movies in descending order.

SELECT * FROM rental;
#this table has rental_id and inventory_id

SELECT * FROM inventory;
#this table has inventory_id and film_id

SELECT * FROM film;
#this table has film_id and title

SELECT film.title, COUNT(rental_id) AS title_rental

	FROM rental
    
    JOIN inventory ON (rental.inventory_id = inventory.inventory_id)
    
    JOIN film ON (film.film_id = inventory.film_id)
    
    GROUP BY film.title ORDER BY count(rental_id) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT * FROM store;
# this table has store_id and address_id

SELECT * FROM rental;

SELECT * FROM payment;
# this table has amount, rental_id, and staff_id

SELECT * FROM staff;
# this table has store_id

SELECT store_id,

	(SELECT SUM(amount) FROM payment
    
    WHERE staff_id IN
		
        (SELECT store_id  FROM staff
        
			WHERE staff.store_id = store.store_id
            
		)
	)
    FROM store;

#7g. Write a query to display for each store its store ID, city, and country.

SELECT * FROM store;
# this table has store_id and address_id

SELECT * FROM address;
# this table has address_id, address, and city_id

SELECT * FROM city;
# this table has city_id, city, and country_id

SELECT * FROM country;
# this table has country_id and country

SELECT store.store_id, city.city, country.country

	FROM store 
    
		INNER JOIN address
			
			ON store.address_id = address.address_id
            
		INNER JOIN city
        
			ON address.city_id = city.city_id
            
		INNER JOIN country
        
			ON city.country_id = country.country_id;
            
#7h. List the top five genres in gross revenue in descending order.

SELECT * FROM payment;
# this table has rental_id and amount

SELECT * FROM rental;
# this table has rental_id and inventory_id

SELECT * FROM inventory;
# this table has inventory_id and film_id

SELECT * FROM film;
# this table has film_id

SELECT * FROM film_category;
# this table has film_id and category_id

SELECT * FROM category;
# this table has category_id and name

SELECT category.name, SUM(amount) AS Gross

	FROM payment
		
			JOIN rental ON (payment.rental_id = rental.rental_id)
            
            JOIN inventory ON (inventory.inventory_id = rental.inventory_id)
            
            JOIN film ON (film.film_id = inventory.film_id)
            
            JOIN film_category ON (film_category.film_id = film.film_id)
            
            JOIN category ON (category.category_id = film_category.category_id)
            
            GROUP BY category.name ORDER BY sum(amount) DESC;


#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.    

SELECT category.name, SUM(amount) AS Gross

	FROM payment
		
			JOIN rental ON (payment.rental_id = rental.rental_id)
            
            JOIN inventory ON (inventory.inventory_id = rental.inventory_id)
            
            JOIN film ON (film.film_id = inventory.film_id)
            
            JOIN film_category ON (film_category.film_id = film.film_id)
            
            JOIN category ON (category.category_id = film_category.category_id)
            
            GROUP BY category.name ORDER BY sum(amount) DESC LIMIT 5;

	    
#8b. How would you display the view that you created in 8a?

CREATE VIEW TOP_GENRE AS 

SELECT category.name, SUM(amount) AS Gross

	FROM payment
		
			JOIN rental ON (payment.rental_id = rental.rental_id)
            
            JOIN inventory ON (inventory.inventory_id = rental.inventory_id)
            
            JOIN film ON (film.film_id = inventory.film_id)
            
            JOIN film_category ON (film_category.film_id = film.film_id)
            
            JOIN category ON (category.category_id = film_category.category_id)
            
            GROUP BY category.name ORDER BY sum(amount) DESC LIMIT 5;
            
SELECT * FROM TOP_GENRE;


#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
    
DROP VIEW TOP_GENRE;




    

    
    




    
    
    

        
        
        







