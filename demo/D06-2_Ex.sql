/*
** This file contains examples from Module 7: 
** "Creating and Maintaining Indexes"
** To use the file, highlight and execute each example.
*/

USE Northwind
GO

/*
**  Creating and Dropping Indexes.
*/
CREATE  INDEX CL_lastname ON employees(lastname)
DROP INDEX employees.CL_lastname

/*
**  Creating Unique Indexes.
*/
CREATE UNIQUE NONCLUSTERED INDEX U_CustID
	ON customers(CustomerID)

SELECT CustomerID, COUNT(CustomerID) AS '# of Duplicates'
FROM Northwind.dbo.Customers
GROUP BY CustomerID
HAVING COUNT(CustomerID)>1
ORDER BY CustomerID

/*
**  Creating Composite Indexes.
*/
CREATE UNIQUE NONCLUSTERED INDEX U_OrdID_ProdID
ON [Order Details] (OrderID, ProductID)

/*
**  Obtaining Information on Existing Indexes.
*/
EXEC sp_helpindex Customers


--  Create INDEX .
CREATE INDEX OrderID_ind ON Orders(OrderID)


/*  Using the PAD_INDEX Option.
CREATE INDEX OrderID_ind ON Orders(OrderID)
	WITH PAD_INDEX, FILLFACTOR=10
*/


/*
**  DBCC SHOWCONTIG Statement.
*/
DBCC SHOWCONTIG (Customers, PK_Customers)

/*
**   
*/

CREATE UNIQUE NONCLUSTERED INDEX U_OrdID_ProdID
ON [Order Details] (OrderID, ProductID)
WITH DROP_EXISTING, FILLFACTOR=65

/*
**  DROP_EXISTING Option.
*/
SELECT id, indid, reserved, used, origfillfactor, name
FROM Northwind.dbo.sysindexes
WHERE name = 'PK_customers'

GO
