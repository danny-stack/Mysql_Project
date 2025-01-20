CREATE DATABASE IF NOT EXISTS Little_Lemon_DB;
USE Little_Lemon_DB;

CREATE TABLE Customers (
CustomerID INT NOT NULL PRIMARY KEY, 
FullName VARCHAR(100) NOT NULL, 
PhoneNumber INT NOT NULL UNIQUE);

INSERT INTO Customers(CustomerID, FullName, PhoneNumber) VALUES 
(1, "Vanessa McCarthy", 0757536378), 
(2, "Marcos Romero", 0757536379), 
(3, "Hiroki Yamane", 0757536376), 
(4, "Anna Iversen", 0757536375), 
(5, "Diana Pinto", 0757536374),     
(6, "Altay Ayhan", 0757636378),      
(7, "Jane Murphy", 0753536379),      
(8, "Laurina Delgado", 0754536376),      
(9, "Mike Edwards", 0757236375),     
(10, "Karl Pederson", 0757936374);

SELECT * FROM Customers;

CREATE TABLE Bookings (
BookingID INT, 
BookingDate DATE,
TableNumber INT, 
NumberOfGuests INT,
CustomerID INT); 

INSERT INTO Bookings 
(BookingID, BookingDate, TableNumber, NumberOfGuests, CustomerID) 
VALUES 
(10, '2021-11-10', 7, 5, 1),  
(11, '2021-11-10', 5, 2, 2),  
(12, '2021-11-10', 3, 2, 4), 
(13, '2021-11-11', 2, 5, 5),  
(14, '2021-11-11', 5, 2, 6),  
(15, '2021-11-11', 3, 2, 7), 
(16, '2021-11-11', 3, 5, 1),  
(17, '2021-11-12', 5, 2, 2),  
(18, '2021-11-12', 3, 2, 4), 
(19, '2021-11-13', 7, 5, 6),  
(20, '2021-11-14', 5, 2, 3),  
(21, '2021-11-14', 3, 2, 4);

SELECT * FROM Bookings;

CREATE TABLE Courses (
CourseName VARCHAR(255) PRIMARY KEY, 
Cost Decimal(4,2));

INSERT INTO Courses (CourseName, Cost) VALUES 
("Greek salad", 15.50), 
("Bean soup", 12.25), 
("Pizza", 15.00), 
("Carbonara", 12.50), 
("Kabasa", 17.00), 
("Shwarma", 11.30);

SELECT * FROM Courses;

####################################################

# Task 1: Print all records from Bookings table for the following bookings dates:
# 2021-11-11, 2021-11-12 and 2021-11-13. 
SELECT * FROM Bookings WHERE BookingDate BETWEEN "2021-11-11" AND "2021-11-13";

# Task 2: Print the customers full names and related bookings IDs from the date 2021-11-11.
SELECT c.FULLNAME, b.BookingID 
FROM Customers AS c 
INNER JOIN Bookings AS b
ON c.CustomerID = b.CustomerID
WHERE b.BookingDate = "2021-11-11";

# Task 3: Print the total number of bookings placed on each of the 
# printed dates using the GROUP BY BookingDate. 
SELECT BookingDate, COUNT(BookingDate) FROM Bookings
GROUP BY BookingDate;

# Task 4: Updates the cost of the Kabsa course from $17.00 to $20.00
REPLACE INTO Courses VALUES ("Kabasa", 20.00);
SELECT * FROM Courses;

# Task 5: Create a new table called "DeliveryAddress"
CREATE TABLE DeliveryAddress (
	ID INT NOT NULL PRIMARY KEY, 
	Address VARCHAR(255) NOT NULL,
    Type VARCHAR(100) NOT NULL DEFAULT "Private",
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
);

SHOW columns FROM DeliveryAddress;

# Task 6: adds a new column called 'Ingredients' to the Courses table.
ALTER TABLE Courses ADD COLUMN Ingredients VARCHAR(255);
SHOW columns FROM Courses;

# Task 7: prints the full names of all customers who made bookings 
# in the restaurant on the following date: 2021-11-11
SELECT FullName FROM Customers WHERE 
(SELECT CustomerID FROM Bookings WHERE Customers.CustomerID = Bookings.CustomerID AND BookingDate = "2021-11-11");

# Task 8: Create the "BookingsView" virtual table to print all bookings IDs, 
# bookings dates and the number of guests for bookings made in the restaurant 
# before 2021-11-13 and where number of guests is larger than 3.

CREATE VIEW BookingsView AS 
SELECT BookingID, BookingDate, NumberOfGuests FROM Bookings
WHERE BookingDate < "2021-11-13" AND NumberOfGuests > 3;
SELECT * FROM BookingsView;

# Task 9: Create a stored procedure called 'GetBookingsData' which contain one date parameter "InputDate". 
# This parameter retrieves all data from the Bookings table based on the user input of the date.
CREATE PROCEDURE GetBookingsData (InputDate DATE)
SELECT * FROM Bookings 
WHERE BookingDate = InputDate;

CALL GetBookingsData ('2021-11-13');

# Task 10: using appropriate MySQL string function to list "Booking Details" 
# including booking ID, booking date and number of guests
SELECT CONCAT("ID: ",BookingID,", ","Date: ",BookingDate, ", ","Number of guests: ",NumberOfGuests) 
AS "Booking Details" FROM Bookings;

