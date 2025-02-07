--create Tables--
CREATE TABLE Books(
     Book_ID SERIAL PRIMARY KEY,
	 Title VARCHAR(100),
	 Author VARCHAR(100),
	 Genre VARCHAR(50),
	 Published_Year INT,
	 Price NUMERIC(10,2),
	 Stock INT
);


CREATE TABLE Customers(
     Customer_ID SERIAL PRIMARY KEY,
	 Name VARCHAR(100),
	 Email VARCHAR(100),
	 Phone VARCHAR(15),
	 City VARCHAR(50),
	 Country VARCHAR(150)
);


CREATE TABLE Orders(
     Order_ID SERIAL PRIMARY KEY,
	 Customer_ID INT REFERENCES Customers(Customer_ID),
	 Book_ID INT REFERENCES Books(Book_ID),
	 Order_Date DATE,
	 Quantity INT,
	 Total_Amount NUMERIC(10,2)
);

SELECT*FROM Books;
SELECT*FROM Customers;
SELECT*FROM Orders;

--All books in the "Fiction" genre--
SELECT * FROM Books
WHERE Genre = 'Fiction';

--Books Published after the year 1950--
SELECT * FROM Books
WHERE published_year> '1950';

--All Customers from the Canada--
SELECT* FROM Customers
WHERE country = 'Canada';

--Order placed in November 2023--
SELECT* FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--Total stock of books available--
SELECT SUM(stock) AS Total_Stock
FROM Books;

--Most Expensive book--
SELECT * FROM Books 
ORDER BY Price 
DESC LIMIT 1;

--All customer who ordered more than 1 quantity of book--
SELECT* FROM Orders
WHERE quantity>1;

--All order where the total amount exceeds $20--
SELECT* FROM Orders
WHERE total_amount>20;

--all genre available in books table--
SELECT DISTINCT genre 
FROM Books;

--Book with the lowest stock--
SELECT * FROM Books 
ORDER BY stock
LIMIT 1;

--Total revenue generated from all orders--
SELECT SUM(total_amount) AS Revenue
FROM Orders;

--Total number of books sold for each genre
SELECT b.Genre,SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id= b.book_id
GROUP BY b.Genre;

--Average price of books in the 'Fantasy' genre--
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- customers who have placed at least 2 orders--
SELECT o.customer_id, c.name, COUNT(o.order_id) AS Order_Count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id)>=2;

--The most frequently ordered book--
SELECT o.Book_id, b.title, COUNT(o.order_id) AS Order_Count
FROM Orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY Order_Count DESC LIMIT 1;

--Top 3 most expensive book of 'Fantasy' Genre--
SELECT* FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

-- Total quantity of books sold by each author--
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.Author;

--Cities name where customer who spent over $30 are located--
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o. customer_id = c.customer_id
WHERE o.total_amount> 30;

--Customer who spent the most on orders--
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent DESC LIMIT 1;

--Calculate the stock remaining after fulfilling all orders--
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(quantity),0) AS Order_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id;
