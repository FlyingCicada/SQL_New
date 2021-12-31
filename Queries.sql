/*QUERY 1 - For the first slide*/
SELECT cat_name, quartile, COUNT(quartile)
FROM (SELECT f.title AS mov_name, c.name AS cat_name, f.rental_duration,
	     	 		 NTILE(4) OVER (ORDER BY f.rental_duration) AS quartile
			FROM category c
			JOIN film_category fc
			ON c.category_id = fc.category_id
			JOIN film f
			ON f.film_id = fc.film_id
			WHERE c.name in ('Animation', 'Children', 'Classics', 'Comedy',
											'Family', 'Music')) AS T1
GROUP BY 1, 2
ORDER BY 1, 2;


/*QUERY 2 - For the second slide*/
SELECT  t1.full_name, t1.pay_month, t1.count_permonth, t1.sum_tot
FROM    (SELECT first_name || ' ' || last_name AS full_name,
 				   			date_trunc('month', payment_date) AS pay_month,
		    	    	COUNT(date_trunc('month', payment_date)) AS count_permonth,
 				   			SUM(amount) AS sum_tot
			  FROM customer c
			  JOIN payment p
			  ON p.customer_id = c.customer_id
			  GROUP BY 1, 2) AS t1
JOIN 		(SELECT first_name || ' ' || last_name AS full_name,
								SUM(amount) AS sum_tot
				FROM customer c
				JOIN payment p
				ON p.customer_id = c.customer_id
				GROUP BY 1
				ORDER BY 2 desc
				LIMIT 10) AS t2
ON t1.full_name = t2.full_name
ORDER BY t2.sum_tot;


/*QUERY 3 - For the third slide*/
SELECT  full_name, pay_month, count_permonth, sum_tot,
				LAG(sum_tot) OVER (PARTITION BY full_name ORDER BY pay_month),
				sum_tot - LAG(sum_tot) OVER (PARTITION BY full_name ORDER BY pay_month) AS payment_diff
FROM  (SELECT t1.full_name, t1.pay_month, t1.count_permonth, t1.sum_tot
	  	 FROM (SELECT first_name || ' ' || last_name as full_name,
 				    			 date_trunc('month', payment_date) pay_month,
		    	  			 COUNT(date_trunc('month', payment_date)) count_permonth,
 				   				 SUM(amount) sum_tot
						FROM customer c
						JOIN payment p
						ON p.customer_id = c.customer_id
						GROUP BY 1, 2) AS t1
	  	 JOIN (SELECT first_name || ' ' || last_name AS full_name,
				   				 SUM(amount) AS sum_tot
					  FROM customer c
					  JOIN payment p
					  ON p.customer_id = c.customer_id
					  GROUP BY 1
					  ORDER BY 2 DESC
					  LIMIT 10) AS t2
	  	 ON t1.full_name = t2.full_name
	  	 ORDER BY t2.sum_tot) AS t3;


/*QUERY 4 - For the fourth slide*/
SELECT DATE_PART('month', r.rental_date) AS rental_month,
	     DATE_PART('year', r.rental_date) AS rental_year,
	     i.store_id AS store_id,
	     COUNT(i.store_id)
FROM inventory i
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY 3, 2, 1
ORDER BY 1, 2, 4 DESC;
