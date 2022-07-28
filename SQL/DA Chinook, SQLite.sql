-- Seleccion de clientes que viven en la misma ciudad


/*SELECT A.FirstName AS a_name, B.FirstName AS B_name,
A.City
FROM customers AS A, customers AS B
WHERE A.CustomerId = B.CustomerId 
AND A.City = B.City
ORDER BY A.City;/**/


-- 
/*SELECT TrackId, Name
FROM tracks
WHERE AlbumId IN
(SELECT AlbumId FROM albums
WHERE Title = 'Californication');/**/

--

/**SELECT c.CustomerId, LastName, FirstName, City, Email
FROM customers AS c
INNER JOIN invoices AS i 
ON c.CustomerId = i.CustomerId
GROUP by c.CustomerId; /*/

---

/**SELECT a.ArtistId, a.AlbumId, a.Title, t.TrackId, t.Name
FROM albums AS a, tracks AS t
WHERE a.AlbumId = t.AlbumId;/*/


--
/*SELECT a.EmployeeId,  a.LastName, b.LastName, b.ReportsTo
fROM employees as a, employees as b
WHERE b.ReportsTo = 6
AND A.LastName = 'Mitchell';/*/

/*SELECT empa.employeeid, 
       empa.firstname, 
       empa.lastname, 
       empb.firstname AS 'Reports to Manager' 
FROM   employees empa 
       INNER JOIN employees empb 
               ON empa.reportsto = empb.employeeid  /*/


/*SELECT FirstName, LastName
from Employees
UNION
Select  Firstname, Lastname
From customers
ORDER BY 2 DESC/*/


/*
SELECT CustomerId, BillingCity
FROM invoices
WHERE BillingCity = 'Delhi'/*/


/*SELECT c.CustomerId, c.City, i.BillingCity
FROM customers AS c
LEFT JOIN invoices AS i ON c.CustomerId = i.CustomerId
WHERE c.City <> i.BillingCity;/*/

/*Select Cust.CustomerID, Cust.City, 
Inv.BillingCity
From Customers as cust
Left join Invoices as Inv ON Cust.CustomerId = Inv.CustomerId;/*/

SELECT InvoiceDate FROM invoices;

