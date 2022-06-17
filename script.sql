--|Advanced PostgreSQL
--|-justice-Nana.Ellis
--|Intermediate Book Store Indexes

--Task 1 | Selecting 1st 10 rows from each table
SELECT *
FROM customers
LIMIT 10;

SELECT *
FROM orders
LIMIT 10;

SELECT *
FROM books
LIMIT 10;

--Task 2 | Viewing the indexes that already exists on the tables 
SELECT *
FROM pg_Indexes
WHERE tablename = 'customers';

SELECT *
FROM pg_Indexes
WHERE tablename = 'books';

SELECT *
FROM pg_Indexes
WHERE tablename = 'orders';

--Task 3 | EXPLAIN ANALYZE on a SELECT query without an index 
EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE orders.quantity > 18;

--Task 4 | Creating an index
CREATE INDEX orders_more_than_18_idx
ON orders(quantity)
WHERE quantity > 18;

--Task 5 | EXPLAIN ANALYZE on a SELECT query with an index 
EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE orders.quantity > 18;

--Task 6 | Creating a primary key for the customers table and checking its effectiveness
EXPLAIN ANALYZE 
SELECT *
FROM customers
WHERE customer_id < 100;

ALTER TABLE customers
  ADD CONSTRAINT customers_pkey
    PRIMARY KEY (customer_id);

EXPLAIN ANALYZE 
SELECT *
FROM customers
WHERE customer_id < 100;

--Task 7 | Creating a clustered Index 
CLUSTER customers USING customers_pkey;

SELECT *
FROM customers
LIMIT 10;

--Task 8 | Creating a multicolumn index 
CREATE INDEX orders_customer_id_book_id_idx
ON orders(customer_id, book_id);

--Task 9 | Dropping the query in Q8. and recreating it with an additional column added
EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE orders.quantity > 18;

DROP INDEX IF EXISTS orders_customer_id_book_id_idx;

CREATE INDEX orders_customer_id_book_id_quantity_idx
ON orders(customer_id, book_id, quantity);

EXPLAIN ANALYZE
SELECT customer_id, quantity
FROM orders
WHERE orders.quantity > 18;

--Task 10 | Creating a multicolumn index 
CREATE INDEX books_author_title_idx
ON books(author, title);

--Task 11 | Testing the runtime of a query
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE (quantity * price_base) > 100;

--Task 12 | Creating an index
CREATE INDEX orders_total_price_idx 
ON orders ((quantity * price_base));

--Task 13 | Testing to see if the query in Q12 worked 
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE (quantity * price_base) > 100;

--Task 14 | Experimenting with the tables 
SELECT *
FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;