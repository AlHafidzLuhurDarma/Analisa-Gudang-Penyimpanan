-- Simpel EDA (Exploanatory Data Analysis)


SELECT * FROM warehouse.gold_dim_customers;
/*
gold_dim_customers

Dimension : customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, gender, create_date
Measures : birthdate (Age)
*/

SELECT * FROM warehouse.gold_dim_products;
/*
gold_dim_products

Dimension : product_key, product_id, product_name, category_id, category, subcategory, maintenance, product_line, start_date
Measures : cost,
*/

SELECT * FROM warehouse.gold_fact_sales;
/*
gold_fact_sales

Dimension : order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount
Measures : sales_amount, quantity, price
*/

/*
TABLES CONNECTIONS
warehouse.gold_fact_sales (customer_key) gold_dim_customers
warehouse.gold_fact_sales (product_key) gold_dim_products
*/

-- Simple dimensions explorations
SELECT DISTINCT category, subcategory, product_name FROM warehouse.gold_dim_products;

-- ********************  Date explorations **************

SELECT customer_id,birthdate,create_date FROM warehouse.gold_dim_customers;

SELECT MIN(create_date) AS first_create,
		MAX(create_date) AS last_create,
        TIMESTAMPDIFF(DAY,MIN(create_date), MAX(create_date)) AS creation_range_days,
        TIMESTAMPDIFF(MONTH, MIN(create_date), MAX(create_date)) AS creation_range_month
FROM warehouse.gold_dim_customers;

-- Pelanggan termuda dan tertua
SELECT MIN(birthdate) AS oldest_birth,
		TIMESTAMPDIFF(YEAR, MIN(birthdate), CURDATE()) AS oldest_age,
		MAX(birthdate) AS youngest_birth,
        TIMESTAMPDIFF(YEAR, MAX(birthdate), CURDATE()) AS youngest_age
FROM warehouse.gold_dim_customers
WHERE birthdate NOT LIKE ""  -- terdapat 17 data kosong dalam date dari 18484 data
;
/*
SELECT COUNT(birthdate) FROM warehouse.gold_dim_customers
WHERE birthdate LIKE ""
*/


-- ************** Measures ***************
-- Total Penjualan
SELECT SUM(sales_amount) AS amount_of_revenue
FROM warehouse.gold_fact_sales;
-- How unit terjual
SELECT SUM(quantity) AS amount_of_items_sold
FROM warehouse.gold_fact_sales;
-- Rata-rata harga penjualan
SELECT AVG(price) AS average_price
FROM warehouse.gold_fact_sales;
-- Total pemesanan
SELECT COUNT(order_number) AS amount_of_order,
		COUNT(DISTINCT(order_number)) AS amount_of_unique_products
FROM warehouse.gold_fact_sales;
-- Total produk
SELECT COUNT(product_key) AS amount_of_product
FROM warehouse.gold_fact_sales;
-- Total pelanggan
SELECT COUNT(customer_key) AS amount_of_customer
FROM warehouse.gold_dim_customers;
-- Total pelanggan yang telah memesan
SELECT COUNT(DISTINCT(customer_key)) AS amount_of_customer_buying
FROM warehouse.gold_fact_sales;

SELECT "Total Sales" AS measure_name,SUM(sales_amount) AS measure_value FROM warehouse.gold_fact_sales
UNION ALL
SELECT "Total Quantity" AS measure_name,SUM(quantity) AS measure_value FROM warehouse.gold_fact_sales
UNION ALL
SELECT "Average price" AS measure_name,AVG(price) AS measure_value FROM warehouse.gold_fact_sales
UNION ALL
SELECT "Total Order" AS measure_name, COUNT(order_number) AS measure_value FROM warehouse.gold_fact_sales
UNION ALL
SELECT "Total Product" AS measure_name,COUNT(product_name) AS measure_value FROM warehouse.gold_dim_products
UNION ALL
SELECT "Total Customer" AS measure_name,COUNT(customer_key) AS measure_value FROM warehouse.gold_dim_customers
;


-- **************** Magnitude **************************

-- Total pelanggan berdasarkan negara
SELECT country,
		COUNT(customer_key) AS amount_customer
FROM warehouse.gold_dim_customers
GROUP BY 1
ORDER BY 2 DESC;

-- Total pelanggan berdasarkan gender
SELECT gender,
		COUNT(customer_key) AS amount_customer
FROM warehouse.gold_dim_customers
GROUP BY 1;

-- Total produk berdasarkan kategori
SELECT category,
		COUNT(product_key) AS amount_of_product
FROM warehouse.gold_dim_products
GROUP BY 1 
ORDER BY 2 DESC
;
-- Rata-rata Harga jual tiap kategori 
SELECT category,
		AVG(cost) AS average_cost
FROM warehouse.gold_dim_products
GROUP BY 1
ORDER BY 2 DESC;

-- Total Revenue dari setiap kategori
SELECT product.category AS category,
		SUM(sales.sales_amount) AS total_sales
FROM warehouse.gold_dim_products product
LEFT JOIN warehouse.gold_fact_sales sales
ON product.product_key=sales.product_key
GROUP BY 1
ORDER BY 2 DESC;

-- Total revenue dari setiap pelanggan
SELECT customer.customer_key AS customer_key,
		CONCAT(customer.first_name, " " ,customer.last_name) AS customer_name,
		SUM(sales.sales_amount) AS total_sales
FROM warehouse.gold_dim_customers customer
LEFT JOIN warehouse.gold_fact_sales sales
ON customer.customer_key=sales.customer_key
GROUP BY 1,2
ORDER BY 3 DESC;

-- Distribusi dari total unit yang terjual dari setiap negara
SELECT customer.country,
		SUM(sales.quantity) AS total_quantity
FROM warehouse.gold_dim_customers customer
LEFT JOIN warehouse.gold_fact_sales sales
ON customer.customer_key=sales.customer_key
GROUP BY 1
ORDER BY 2 DESC
;

-- *********************** Ranking Analysis **************************

-- Top 5 produk berdasarkan penjualan
SELECT product.product_id,
		SUM(sales.sales_amount) AS revenue
FROM warehouse.gold_dim_products product
LEFT JOIN warehouse.gold_fact_sales sales
ON product.product_key=sales.product_key
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;

-- Produk terbaik (menggunakan window function)
SELECT *
FROM (
SELECT product.product_name,
		SUM(sales.sales_amount) AS revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(sales.sales_amount) DESC) AS rank_product
FROM warehouse.gold_dim_products product
JOIN warehouse.gold_fact_sales sales
ON product.product_key=sales.product_key
GROUP BY 1
) t
WHERE rank_product <=5
;

-- Produk terburuk berdasarkan penjualan
SELECT product.product_id,
		SUM(sales.sales_amount) AS revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(sales.sales_amount) ASC) AS rank_product
FROM warehouse.gold_dim_products product
JOIN warehouse.gold_fact_sales sales
ON product.product_key=sales.product_key
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5
;

-- ************** Changes over time (TRENDS) **********************

SELECT YEAR(order_date) AS order_year,
		SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customer
FROM warehouse.gold_fact_sales
WHERE order_date NOT LIKE ""
GROUP BY 1
ORDER BY 1;

SELECT YEAR(order_date) AS year_date,
		MONTH(order_date) AS month_date,
		SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customer
FROM warehouse.gold_fact_sales
WHERE order_date NOT LIKE ""
GROUP BY 1,2
ORDER BY 1,2;

-- *************** Cumulative Analysis ******************

-- Total penjualan per bulan dan total penjualan berdasarkan waktu
WITH sales_overtime AS (
SELECT	YEAR(order_date) AS year_date,
		MONTH(order_date) AS month_date,
		SUM(sales_amount) AS total_sales
FROM warehouse.gold_fact_sales
WHERE order_date NOT LIKE ""
GROUP BY 1, 2)
SELECT year_date,
	month_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY year_date, month_date) AS running_total_sales
FROM sales_overtime;



-- Total penjualan dan perubahan rata-rata harga per bulan dan perubahan total penjualan setiap tahun
WITH sales_overtime AS (
SELECT	YEAR(order_date) AS year_date,
		MONTH(order_date) AS month_date,
		SUM(sales_amount) AS total_sales,
        ROUND(AVG(price),2) AS average_price
FROM warehouse.gold_fact_sales
WHERE order_date NOT LIKE ""
GROUP BY 1, 2)
SELECT year_date,
	month_date,
    total_sales,
    SUM(total_sales) OVER (PARTITION BY year_date ORDER BY year_date, month_date) AS running_total_sales,
    average_price,
    ROUND(AVG(average_price) OVER (PARTITION BY year_date ORDER BY year_date, month_date),2) AS running_average_price
FROM sales_overtime;


-- ******************* Performance analysis *********************


-- Analisa performa setiap tahun dari produk dengan membandingkan setiap produk dengan rata-rata performa
-- penjualan pada bulan sebelumnya
WITH yearly_sales AS (
SELECT YEAR(sales.order_date) AS order_year,
		product.product_name,
        SUM(sales.sales_amount) AS current_sales
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_products product
ON sales.product_key=product.product_key
WHERE order_date NOT LIKE ""
GROUP BY 1,2
)
SELECT order_year,
		product_name,
        current_sales,
        AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
        current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS difference_avg,
        CASE 
			WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0  THEN "Above Average"
			WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0  THEN "Under Average"
            ELSE "Average"
		END average_change,
        LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
        current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS difference_previous_year,
        CASE 
			WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0  THEN "Increased"
			WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0  THEN "Decreased"
            ELSE "No change"
		END previous_year_change
FROM yearly_sales
ORDER BY 2,1;

-- ********************* Part-to-Whole Analysis **********************

-- Kategori mana yang memiliki kontribusi paling tinggi pada penjualan?
WITH category_sales AS (
SELECT product.category, 
		SUM(sales.sales_amount) AS total_sales
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_products product
ON sales.product_key=product.product_key
GROUP BY 1
)
SELECT category,
		total_sales,
        SUM(total_sales) OVER() AS overall_sales,
        CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100,2), "%") AS percentage_total
FROM category_sales
ORDER BY 4 DESC;


-- ******************** Data Segmentation ********************

-- ssegmentasi produk berdasarkan harga
WITH product_segment AS(
SELECT product_key,
		product_name,
        cost,
        CASE 
			WHEN cost < 100 THEN "Below 100"
            WHEN cost BETWEEN 100 AND 500 THEN "100-500"
            WHEN cost BETWEEN 500 AND 1000 THEN "500-1000"
            ELSE "Above 1000"
		END cost_range
FROM warehouse.gold_dim_products
)
SELECT cost_range,
	COUNT(product_key) AS amount_of_product
FROM product_segment
GROUP BY 1
ORDER BY 2 DESC;

/*
Bagi pelanggan menjadi 3 segmen dengan syarat sebagai berikut:
	- VIP : Pelanggan dengan setidaknya lebih dari 12 bulan dan menghabiskan 50000
    - Regular : Pelanggan dengan kurang dari 12 bulan namun pengeluaran menghabiskan 50000 atau kurang
    - New : Pelanggan yang kurang dari 12 bulan
Temukan total pelanggan pada setiap segmen
*/
WITH customer_spending AS(
SELECT customer.customer_key,
		SUM(sales.sales_amount) AS total_spending,
        MIN(sales.order_date) AS first_order,
        MAX(sales.order_date) AS last_order,
        TIMESTAMPDIFF(MONTH,MIN(sales.order_date), MAX(sales.order_date)) AS lifespan
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_customers customer
ON sales.customer_key=customer.customer_key
GROUP BY 1
)
SELECT customer_key,
		total_spending,
		CONCAT(lifespan, " months") AS lifespan,
        CASE 
			WHEN total_spending > 5000 AND lifespan > 12 THEN "VIP"
            WHEN total_spending < 5000 AND lifespan > 12 THEN "Regular"
            ELSE "New Customer"
		END customer_class
FROM customer_spending;

-- Total pelanggan pada setiap segmen
WITH customer_spending AS(
SELECT customer.customer_key,
		SUM(sales.sales_amount) AS total_spending,
        MIN(sales.order_date) AS first_order,
        MAX(sales.order_date) AS last_order,
        TIMESTAMPDIFF(MONTH,MIN(sales.order_date), MAX(sales.order_date)) AS lifespan
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_customers customer
ON sales.customer_key=customer.customer_key
GROUP BY 1
)
SELECT customer_class,
		COUNT(customer_key) AS amount_customer
FROM (
SELECT customer_key,
		total_spending,
		CONCAT(lifespan, " months") AS lifespan,
        CASE 
			WHEN total_spending > 5000 AND lifespan >= 12 THEN "VIP"
            WHEN total_spending <= 5000 AND lifespan >= 12 THEN "Regular"
            ELSE "New Customer"
		END customer_class
FROM customer_spending) t
GROUP BY 1
;


/*
===================================================================================
||                                Laporan Pelanggan                              ||
===================================================================================
Tujuan:
	- Laporan ini berisi metrik penting berdasarkan perilaku pelanggan
    
Infomasi Penting:
    1. Mengumpulkan bagian penting seperti nama, umur, dan detail transaksi.
    2. Segmentasi pelanggan ke-dalam 3 kategori(VIP, Regular, dan New Customer) dan grup umur.
    3. Menggabungkan metrik penting:
		- Total orders
        - Total sales
        - Total quantity and purchased
        - Total products
        - Lifespan (months)
	4. KPI:
		- Recency (months since last order)
        - AOV = Total penjualan / total unit yang dipesan
        - Average monthly spend = Total penjualan / jumlah bulan
*/

WITH base_query AS(
SELECT sales.order_number,
		sales.product_key,
        sales.order_date,
        sales.sales_amount,
        sales.quantity,
        customer.customer_key,
        customer.customer_number,
        CONCAT(customer.first_name, " ", customer.last_name) AS customer_name,
        TIMESTAMPDIFF(YEAR, customer.birthdate, CURDATE()) AS age
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_customers customer
ON sales.customer_key=customer.customer_key
WHERE order_date NOT LIKE ""
),
customer_aggregation AS(
SELECT  customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_product,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 1,2,3,4
)
SELECT customer_key,
        customer_number,
        customer_name,
        age,
        CASE 
			WHEN age < 20 THEN "Under 20"
            WHEN age BETWEEN 20 AND 29 THEN "20-29"
            WHEN age BETWEEN 30 AND 39 THEN "30-39"
            WHEN age BETWEEN 40 AND 49 THEN "40-49"
            WHEN age BETWEEN 50 AND 59 THEN "50-59"
			ELSE "60 and Above"
		END AS age_group,
        lifespan,
        CASE 	
			WHEN lifespan >= 12 AND total_sales > 5000 THEN "VIP"
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN "Regular"
            ELSE "New Customer"
		END AS customer_class,
        first_order,
        last_order,
		TIMESTAMPDIFF(MONTH,last_order,CURDATE()) AS since_last_order,
		total_orders,
        total_sales,
        total_quantity,
        total_product,
        ROUND(total_sales/total_orders,2) AS average_order_value,
        CASE 
			WHEN lifespan = 0 THEN total_sales
            ELSE total_sales/lifespan
		END AS average_monthly_spend
FROM customer_aggregation;

/*
===================================================================================
||                                Customer Report                                ||
===================================================================================
Purpose:
	- This report consolidates key product metrics and behaviours
    
Highlight:
    1. Menggabungkan informasi penting seperti nama produk, kategori, sub kategori, dan harga.
    2. Segmentasi produk berdasarkan revenue untuk identifikasi High-Performers, Mid-Range, or Low-Performers.
    3. Menggabungkan metrik penting:
		- Total orders
        - Total sales
        - Total quantity and purchased
        - Total products
        - Lifespan (months)
	4. KPI:
		- Recency (months since last order)
        - AOV = Total penjualan / total unit yang dipesan
        - Average monthly spend = Total penjualan / jumlah bulan
*/


WITH base_query AS(
SELECT sales.order_number,
        sales.order_date,
        sales.customer_key,
        sales.sales_amount,
        sales.quantity,
        product.product_key,
        product.product_name,
        product.category,
        product.subcategory,
        product.cost
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_products product
ON sales.product_key=product.product_key
WHERE order_date NOT LIKE ""
),
product_aggregation AS(
SELECT  product_key,
        product_name,
        category,
        subcategory,
        cost,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_order,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customer,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(sales_amount/quantity),2) AS avg_selling_price
FROM base_query
GROUP BY 1,2,3,4,5
)
SELECT product_key,
        product_name,
        category,
        subcategory,
        cost,
        last_order,
		TIMESTAMPDIFF(MONTH,last_order,CURDATE()) AS since_last_order,
        CASE 
			WHEN total_sales >= 50000 THEN "High-Performer"
            WHEN total_sales >= 10000 THEN "Mid-Range"
            ELSE "Low-Performer"
		END AS product_class,
        lifespan,
		total_orders,
        total_sales,
        total_quantity,
        total_customer,
        ROUND(total_sales/total_orders,2) AS average_order_value,
        CASE 
			WHEN total_orders = 0 THEN 0
            ELSE total_sales/total_orders
		END AS average_order_revenue,
        CASE 
			WHEN lifespan = 0 THEN total_sales
            ELSE total_sales/lifespan
		END AS average_monthly_revenue
FROM product_aggregation;



CREATE TABLE warehouse.product_report AS
WITH base_query AS(
SELECT sales.order_number,
        sales.order_date,
        sales.customer_key,
        sales.sales_amount,
        sales.quantity,
        product.product_key,
        product.product_name,
        product.category,
        product.subcategory,
        product.cost
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_products product
ON sales.product_key=product.product_key
WHERE order_date NOT LIKE ""
),
product_aggregation AS(
SELECT  product_key,
        product_name,
        category,
        subcategory,
        cost,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_order,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customer,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(sales_amount/quantity),2) AS avg_selling_price
FROM base_query
GROUP BY 1,2,3,4,5
)
SELECT product_key,
        product_name,
        category,
        subcategory,
        cost,
        last_order,
		TIMESTAMPDIFF(MONTH,last_order,CURDATE()) AS since_last_order,
        CASE 
			WHEN total_sales >= 50000 THEN "High-Performer"
            WHEN total_sales >= 10000 THEN "Mid-Range"
            ELSE "Low-Performer"
		END AS product_class,
        lifespan,
		total_orders,
        total_sales,
        total_quantity,
        total_customer,
        ROUND(total_sales/total_orders,2) AS average_order_value,
        CASE 
			WHEN total_orders = 0 THEN 0
            ELSE total_sales/total_orders
		END AS average_order_revenue,
        CASE 
			WHEN lifespan = 0 THEN total_sales
            ELSE total_sales/lifespan
		END AS average_monthly_revenue
FROM product_aggregation;


SELECT * FROM warehouse.product_report;

WITH catego AS(
	SELECT DISTINCT(cost),
			category,
			COUNT(subcategory) as amount_of_sub
	FROM warehouse.product_report
    WHERE category = 'Clothing'
	GROUP BY 1,2
	ORDER BY 1 DESC
)
SELECT SUM(amount_of_sub)
FROM catego;


-- Laba dan persentase terhadap keseluruhan keuntungan

WITH base_query AS(
	SELECT sales.order_number,
			sales.order_date,
			sales.sales_amount,
			sales.quantity,
			sales.product_key,
			customer.customer_key,
			CONCAT(customer.first_name, " ", customer.last_name) AS customer_name,
			country
	FROM warehouse.gold_fact_sales sales
	LEFT JOIN warehouse.gold_dim_customers customer
	ON sales.customer_key=customer.customer_key
	WHERE order_date NOT LIKE ""
),
customer_aggregation AS(
	SELECT  customer_key,
			product_key,
			country,
			COUNT(DISTINCT order_number) AS total_orders,
			SUM(sales_amount) AS total_sales,
			SUM(quantity) AS total_quantity,
			COUNT(DISTINCT product_key) AS total_product
	FROM base_query
	GROUP BY 1,2,3
), customer_sales AS(
	SELECT customer_key,
			product_key,
			country,
			total_sales,
			total_quantity,
			total_product
	FROM customer_aggregation
)
SELECT country,
		SUM(total_sales) AS total_sales,
		CONCAT(ROUND((SUM(total_sales)/29351258)*100,2), "%") AS sales_percentage
FROM customer_sales sales
JOIN warehouse.gold_dim_products product
ON sales.product_key=product.product_key
GROUP BY 1;


CREATE TABLE warehouse.customer_report AS(
WITH base_query AS(
SELECT sales.order_number,
		sales.product_key,
        sales.order_date,
        sales.sales_amount,
        sales.quantity,
        customer.customer_key,
        customer.customer_number,
        CONCAT(customer.first_name, " ", customer.last_name) AS customer_name,
        TIMESTAMPDIFF(YEAR, customer.birthdate, '2025-9-01') AS age,
        customer.country
FROM warehouse.gold_fact_sales sales
LEFT JOIN warehouse.gold_dim_customers customer
ON sales.customer_key=customer.customer_key
WHERE order_date NOT LIKE ""
),
customer_aggregation AS(
SELECT  customer_key,
        customer_number,
        customer_name,
        age,
        country,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_product,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 1,2,3,4,5
)
SELECT customer_key,
        customer_number,
        customer_name,
        age,
        country,
        CASE 
			WHEN age < 20 THEN "Under 20"
            WHEN age BETWEEN 20 AND 29 THEN "20-29"
            WHEN age BETWEEN 30 AND 39 THEN "30-39"
            WHEN age BETWEEN 40 AND 49 THEN "40-49"
            WHEN age BETWEEN 50 AND 59 THEN "50-59"
			ELSE "60 and Above"
		END AS age_group,
        lifespan,
        CASE 	
			WHEN lifespan >= 12 AND total_sales > 5000 THEN "VIP"
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN "Regular"
            ELSE "New Customer"
		END AS customer_class,
        first_order,
        last_order,
		TIMESTAMPDIFF(MONTH,last_order,'2025-9-01') AS since_last_order,
		total_orders,
        total_sales,
        total_quantity,
        total_product,
        ROUND(total_sales/total_orders,2) AS average_order_value,
        CASE 
			WHEN lifespan = 0 THEN total_sales
            ELSE total_sales/lifespan
		END AS average_monthly_spend
FROM customer_aggregation
);

SELECT * FROM warehouse.gold_dim_customers;
;SELECT * FROM warehouse.gold_dim_products;
SELECT * FROM warehouse.gold_fact_sales;



--  Wilayah paling mendominasi berdasarkan penjualan kategory dan sub-kategory produk

WITH country_select AS(
	SELECT c.country,
			s.product_key,
			s.quantity,
			s.sales_amount
	FROM warehouse.gold_fact_sales s
	JOIN warehouse.gold_dim_customers c
	ON s.customer_key = c.customer_key
)
SELECT c.country,
        p.category,
        p.subcategory,
		SUM(c.quantity) AS total_kuantitas,
        SUM(c.sales_amount) AS total_penghasilan
FROM country_select c
JOIN warehouse.gold_dim_products p
ON c.product_key=p.product_key
WHERE c.country = "United States"
GROUP BY 1,2,3
ORDER BY 5 DESC;


-- Produk paling mendominasi berdasarkan wilayah

WITH country_select AS(
	SELECT c.country,
			s.product_key,
			s.quantity,
			s.sales_amount
	FROM warehouse.gold_fact_sales s
	JOIN warehouse.gold_dim_customers c
	ON s.customer_key = c.customer_key
)
SELECT p.subcategory,
		c.country,
		SUM(c.quantity) AS total_kuantitas,
        SUM(c.sales_amount) AS total_penghasilan
FROM country_select c
JOIN warehouse.gold_dim_products p
ON c.product_key=p.product_key
WHERE p.subcategory = "Road Bikes"
GROUP BY 1,2
ORDER BY 4 DESC;


# Group usia paling profitable

WITH dataselect AS(
	WITH base_query AS(
	SELECT sales.order_number,
			sales.product_key,
			sales.sales_amount,
			customer.customer_key,
			customer.customer_number,
			CONCAT(customer.first_name, " ", customer.last_name) AS customer_name,
			TIMESTAMPDIFF(YEAR, customer.birthdate, CURDATE()) AS age
	FROM warehouse.gold_fact_sales sales
	LEFT JOIN warehouse.gold_dim_customers customer
	ON sales.customer_key=customer.customer_key
	WHERE order_date NOT LIKE ""
	),
	customer_aggregation AS(
	SELECT  customer_key,
			age,
			COUNT(DISTINCT order_number) AS total_orders,
			SUM(sales_amount) AS total_sales
	FROM base_query
	GROUP BY 1,2
	)
	SELECT customer_key,
			age,
			CASE 
				WHEN age < 20 THEN "Under 20"
				WHEN age BETWEEN 20 AND 29 THEN "20-29"
				WHEN age BETWEEN 30 AND 39 THEN "30-39"
				WHEN age BETWEEN 40 AND 49 THEN "40-49"
				WHEN age BETWEEN 50 AND 59 THEN "50-59"
				ELSE "60 and Above"
			END AS age_group,
			total_sales
	FROM customer_aggregation
)
SELECT age_group,
		SUM(total_sales) AS total_revenue
FROM dataselect
GROUP BY 1;


-- Minat group usia berdasarkan total penjualan produk

WITH base_query AS(
	SELECT sales.order_number,
			sales.order_date,
			sales.sales_amount,
			sales.quantity,
			sales.product_key,
			customer.customer_key,
			customer.customer_number,
			CONCAT(customer.first_name, " ", customer.last_name) AS customer_name,
			TIMESTAMPDIFF(YEAR, customer.birthdate, CURDATE()) AS age
	FROM warehouse.gold_fact_sales sales
	LEFT JOIN warehouse.gold_dim_customers customer
	ON sales.customer_key=customer.customer_key
	WHERE order_date NOT LIKE ""
),
customer_aggregation AS(
	SELECT  customer_key,
			product_key,
			age,
			COUNT(DISTINCT order_number) AS total_orders,
			SUM(sales_amount) AS total_sales,
			SUM(quantity) AS total_quantity,
			COUNT(DISTINCT product_key) AS total_product
	FROM base_query
	GROUP BY 1,2,3
	), customer_sales AS(
	SELECT customer_key,
			product_key,
			age,
			CASE 
				WHEN age < 20 THEN "Under 20"
				WHEN age BETWEEN 20 AND 29 THEN "20-29"
				WHEN age BETWEEN 30 AND 39 THEN "30-39"
				WHEN age BETWEEN 40 AND 49 THEN "40-49"
				WHEN age BETWEEN 50 AND 59 THEN "50-59"
				ELSE "60 and Above"
			END AS age_group,
			total_sales,
			total_quantity,
			total_product
	FROM customer_aggregation
)
SELECT age_group,
		product_name,
        SUM(total_sales) AS total_sales
FROM customer_sales sales
JOIN warehouse.gold_dim_products product
ON sales.product_key=product.product_key
WHERE category="Bikes"  AND age_group = '30-39'
GROUP BY 1,2
ORDER BY 3 DESC
;


-- Minat masing-masing negara terhadap penjualan produk

WITH base_query AS(
	SELECT sales.order_number,
			sales.order_date,
			sales.sales_amount,
			sales.quantity,
			sales.product_key,
			customer.customer_key,
			CONCAT(customer.first_name, " ", customer.last_name) AS customer_name,
			country
	FROM warehouse.gold_fact_sales sales
	LEFT JOIN warehouse.gold_dim_customers customer
	ON sales.customer_key=customer.customer_key
	WHERE order_date NOT LIKE ""
),
customer_aggregation AS(
	SELECT  customer_key,
			product_key,
			country,
			COUNT(DISTINCT order_number) AS total_orders,
			SUM(sales_amount) AS total_sales,
			SUM(quantity) AS total_quantity,
			COUNT(DISTINCT product_key) AS total_product
	FROM base_query
	GROUP BY 1,2,3
), customer_sales AS(
	SELECT customer_key,
			product_key,
			country,
			total_sales,
			total_quantity,
			total_product
	FROM customer_aggregation
)
SELECT country,
		product_name,
        SUM(total_sales) AS total_sales
FROM customer_sales sales
JOIN warehouse.gold_dim_products product
ON sales.product_key=product.product_key
WHERE country = "France"
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;

WITH country_yearly AS(
	SELECT sales.*,
			product.subcategory
	FROM warehouse.gold_dim_products product
	JOIN warehouse.gold_fact_sales sales
	ON product.product_key=sales.product_key
	WHERE YEAR(order_date) = 2012 OR YEAR(order_date) = 2013
)
-- subcategory 14 => 17
SELECT subcategory,
		YEAR(order_date) AS year_order
FROM country_yearly
GROUP BY 1,2;
