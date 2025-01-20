CREATE DATABASE little_lemon; 
USE little_lemon;

CREATE TABLE 
Customers(CustomerID INT NOT NULL PRIMARY KEY, 
FullName VARCHAR(100) NOT NULL, 
PhoneNumber INT NOT NULL UNIQUE);

INSERT INTO Customers(CustomerID, FullName, PhoneNumber) 
VALUES 
(1, "Vanessa McCarthy", 0757536378), 
(2, "Marcos Romero", 0757536379), 
(3, "Hiroki Yamane", 0757536376), 
(4, "Anna Iversen", 0757536375), 
(5, "Diana Pinto", 0757536374);

CREATE TABLE 
Bookings (BookingID INT NOT NULL PRIMARY KEY,  BookingDate DATE NOT NULL,  TableNumber INT NOT NULL, NumberOfGuests INT NOT NULL CHECK (NumberOfGuests <= 8), 
CustomerID INT NOT NULL, FOREIGN KEY (CustomerID) 
REFERENCES Customers (CustomerID) ON DELETE CASCADE ON UPDATE CASCADE); 

INSERT INTO Bookings (BookingID, BookingDate, TableNumber, NumberOfGuests, CustomerID) 
VALUES 
(10, '2021-11-11', 7, 5, 1), 
(11, '2021-11-10', 5, 2, 2), 
(12, '2021-11-10', 3, 2, 4);

DROP TABLE Bookings;

CREATE TABLE MenuItems ( 
  ItemID INT, 
  Name VARCHAR(200), 
  Type VARCHAR(100), 
  Price INT, 
  PRIMARY KEY (ItemID) 
); 

INSERT INTO MenuItems VALUES(1,'Olives','Starters', 5), 
(2,'Flatbread','Starters', 5),
(3, 'Minestrone', 'Starters', 8), 
(4, 'Tomato bread','Starters', 8), 
(5, 'Falafel', 'Starters', 7), 
(6, 'Hummus', 'Starters', 5), 
(7, 'Greek salad', 'Main Courses', 15), 
(8, 'Bean soup', 'Main Courses', 12), 
(9, 'Pizza', 'Main Courses', 15), 
(10,'Greek yoghurt','Desserts', 7), 
(11, 'Ice cream', 'Desserts', 6),
(12, 'Cheesecake', 'Desserts', 4), 
(13, 'Athens White wine', 'Drinks', 25), 
(14, 'Corfu Red Wine', 'Drinks', 30), 
(15, 'Turkish Coffee', 'Drinks', 10), 
(16, 'Turkish Coffee', 'Drinks', 10), 
(17, 'Kabasa', 'Main Courses', 17);

CREATE TABLE Menus ( 
  MenuID INT, 
  ItemID INT, 
  Cuisine VARCHAR(100), 
  PRIMARY KEY (MenuID,ItemID)
); 
CREATE VIEW MenusView AS SELECT MenuID, Cuisine FROM Menus; 
SELECT * FROM MenusView;
DROP VIEW MenusView; 

INSERT INTO Menus VALUES
(1, 1, 'Greek'), (1, 7, 'Greek'), 
(1, 10, 'Greek'), (1, 13, 'Greek'), 
(2, 3, 'Italian'), (2, 9, 'Italian'), 
(2, 12, 'Italian'), (2, 15, 'Italian'), 
(3, 5, 'Turkish'), (3, 17, 'Turkish'), 
(3, 11, 'Turkish'), (3, 16, 'Turkish');

CREATE TABLE Bookings ( 
  BookingID INT, 
  TableNo INT, 
  GuestFirstName VARCHAR(100), 
  GuestLastName VARCHAR(100), 
  BookingSlot TIME, 
  EmployeeID INT, 
  PRIMARY KEY (BookingID) 
);  

INSERT INTO Bookings VALUES
(1,12,'Anna','Iversen','19:00:00',1), (2, 12, 'Joakim', 'Iversen', '19:00:00', 1), 
(3, 19, 'Vanessa', 'McCarthy', '15:00:00', 3), (4, 15, 'Marcos', 'Romero', '17:30:00', 4), 
(5, 5, 'Hiroki', 'Yamane', '18:30:00', 2), (6, 8, 'Diana', 'Pinto', '20:00:00', 5); 

# Write a SQL SELECT query to find all bookings that are due after the booking of the guest ‘Vanessa McCarthy’.
SELECT * FROM Bookings WHERE BookingSlot > 
(SELECT BookingSlot FROM Bookings WHERE GuestFirstName = 'Vanessa' AND GuestLastName = 'McCarthy');

# Write a SQL SELECT query to find the menu items that costs the same as the starter menu items that are Italian cuisine.
SELECT * FROM MenuItems WHERE Price = 
(SELECT MenuItems.Price FROM Menus, MenuItems 
WHERE Menus.ItemID = MenuItems.ItemID
AND MenuItems.Type = 'starters'
AND Menus.Cuisine = 'Italian');

# Write a SQL SELECT query to find the menu items that were not ordered by the guests who placed bookings.
SELECT * FROM MenuItems 
WHERE NOT EXISTS 
(SELECT * FROM TableOrders, Menus 
WHERE TableOrders.MenuID = Menus.MenuID 
AND Menus.ItemID = MenuItems.ItemID); 

CREATE TABLE TableOrders ( 
  OrderID INT, 
  TableNo INT, 
  MenuID INT, 
  BookingID INT, 
  BillAmount INT, 
  Quantity INT, 
  PRIMARY KEY (OrderID,TableNo) 
);  

INSERT INTO TableOrders VALUES
(1, 12, 1, 1, 2, 86), (2, 19, 2, 2, 1, 37), 
(3, 15, 2, 3, 1, 37), (4, 5, 3, 4, 1, 40), 
(5, 8, 1, 5, 1, 43);

# SELECT * FROM Bookings;

##########################3##########################

SELECT c.fullname, c.phonenumber, b.bookingdate, b.numberofguests
FROM customers AS c
INNER JOIN bookings AS b
ON c.customerid = b.customerid;

SELECT c.customerid, b.bookingid
FROM customers AS c
LEFT JOIN bookings AS b
ON c.customerid = b.customerid;

##########################3##########################
SELECT Price,
CASE
	WHEN Price > (SELECT AVG(Price) FROM Menuitems) THEN "Above AVG"
    ELSE "Under AVG"
END AS Evaluate
FROM MenuItems;

CREATE PROCEDURE GetMenusBasedOnPrice (inputPrice INT) 
SELECT * FROM Menuitems WHERE Price <= inputPrice;

CALL GetMenusBasedOnPrice (10);
