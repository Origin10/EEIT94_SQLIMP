/*
** This file contains examples from 'Module 11: 'Implementing
** Triggers'
** To use the file, highlight and execute each example.
*/

/*
** Data Control Language Statements
**
** This example grants the public role permission to query the Products table
*/

USE Northwind
GO

--��1 �إ� Trigger
--���ʹ��ո�ƪ�
select * into employees2 from Employees

--�إ� Trigger �� �R�� employees ���u�W�L�@���H�W��, ���Ϳ��~�T��
Use Northwind
GO
CREATE TRIGGER Empl_Delete ON Employees2
FOR DELETE 
AS
IF (SELECT COUNT(*) FROM Deleted) > 1
BEGIN
   RAISERROR('You cannot delete more than one employee at a time.', 16, 1)
   ROLLBACK TRANSACTION
END

--����
delete from employees2 where employeeid >= 1      -- not OK
delete from employees2 where employeeid  = 1      -- OK

go
--��2 �ק�P�R�� Trigger

USE Northwind

ALTER   TRIGGER   Empl_Delete   ON   Employees2
FOR  DELETE 
AS
IF (SELECT COUNT(*) FROM Deleted) > 6
BEGIN
   RAISERROR('You cannot delete more than six employees at a time.', 16, 1)
   ROLLBACK 
END

--�R�� Trigger

DROP TRIGGER Empl_Delete;
drop table employees2;
go


--INSERT Trigger

/*
** This example creates the OrdDet_Insert trigger 
** for the INSERT action on the Order Details table. When a row 
** is inserted into the Order Details table, the trigger updates 
** the UnitsInStock column of the Product table with reducing 
** the UnitsInStock by the amount of the order
*/

CREATE TRIGGER OrdDet_Insert
ON [Order Details]
FOR INSERT
AS
UPDATE P SET 
UnitsInStock = (P.UnitsInStock - I.Quantity)
FROM Products AS P INNER JOIN Inserted AS I
ON P.ProductID = I.ProductID

--����2

select productid, unitsinstock '��w�s' from products where productid = 1

--�ʶR���~ productid = 1 , 5�ӫ�
insert into [Order Details] values (10248, 1,14.00, 5,0)

select productid, unitsinstock  '�s�w�s' from products where productid = 1

drop trigger OrdDet_Insert

--��g����@���l, �Y�T�w�u�|���@���Q�v�T��
CREATE TRIGGER OrdDet_Insert2
ON [Order Details]
FOR INSERT
AS
BEGIN
 declare @pid int;
 declare @qty int;

 select @pid = productid ,@qty = quantity 
 from   INSERTED;

 UPDATE Products  SET UnitsInStock = (UnitsInStock - @qty)
 where ProductID = @pid
END

--DELETE Trigger


/*
** How a DELETE trigger works
**
** The trigger in this example was created 
** to update the Discontinued column in the 
** Products table whenever a Category is deleted 
** (whenever a record is deleted from the 
** Categories table). All affected products 
** are marked as 1 indicating they are discontinued.
*/

--���ʹ��ո��
drop table Categories1
drop table products1  

select * into Categories1 from Categories
select * into products1   from products 
GO
CREATE TRIGGER Category_Delete
	ON Categories1
	FOR DELETE
AS
	UPDATE P SET Discontinued = 1
		FROM Products1 AS P INNER JOIN deleted AS d
		ON P.CategoryID = d.CategoryID

--����
select * from Categories1  where categoryid = 4
select productid, categoryid, discontinued from products1 where categoryid = 4

delete from Categories1  where categoryid = 4

--�R����
select * from Categories1  where categoryid = 4
select productid, categoryid, discontinued from products1 where categoryid = 4
GO


------------------------------------
--UPDATE Trigger
/*
** How an UPDATE trigger works
**
** This example prevents a user from modifying 
** the EmployeeID column in the Employees table.
*/

IF EXISTS (SELECT name FROM sys.objects
      WHERE name = 'Employee_Update' AND type = 'TR')
   DROP TRIGGER Employee_Update;
GO
create TRIGGER Employee_Update
	ON Employees
	FOR UPDATE
AS
begin
IF UPDATE (EmployeeID) or UPDATE (title)
  begin
   BEGIN TRANSACTION
	RAISERROR ('Transaction cannot be processed.\
	***** Employee ID number or Job title cannot be modified.', 10, 1)
	ROLLBACK TRANSACTION
  end
end
GO
----����
 
update employees set title= 'Sales' where employeeid = 1   --Ĳ�o�L�k��s tile
update employees set employeeid = 11 where employeeid = 1  --�L�k��s�ѧO��� 'EmployeeID'�C
update employees set lastname='King2' where lastname='King' --OK 
/*
** How an INSTEAD OF trigger works
**
** This example creates a table with customers 
** in Germany and a table with customers in Mexico. 
** An INSTEAD OF trigger placed on the view redirects 
** updates to the appropriate underlying table. The 
** insert to the CustomersGer table occurs instead 
** of the insert to the view.
*/

--Create two tables with customer data
USE Northwind
GO
SELECT * INTO CustomersGer FROM Customers WHERE Customers.Country = 'Germany'
SELECT * INTO CustomersMex FROM Customers WHERE Customers.Country = 'Mexico'
GO

--Create a view on that data
CREATE VIEW CustomersView AS
SELECT * FROM CustomersGer
UNION
SELECT * FROM CustomersMex
GO

--Create an INSTEAD OF trigger on the view
CREATE TRIGGER Customers_Update2
ON CustomersView
INSTEAD OF UPDATE AS
DECLARE @Country nvarchar(15)
SET @Country = (SELECT Country FROM Inserted)
IF @Country = 'Germany'
  BEGIN 
   UPDATE CustomersGer
    SET CustomersGer.Phone = Inserted.Phone
    FROM CustomersGer JOIN Inserted 
    ON CustomersGer.CustomerID = Inserted.CustomerID
  END
ELSE 
  IF @Country = 'Mexico' 
  BEGIN
   UPDATE CustomersMex
    SET CustomersMex.Phone = Inserted.Phone
    FROM CustomersMex JOIN Inserted 
    ON CustomersMex.CustomerID = Inserted.CustomerID
  END
  
--Test the trigger by updating the view
UPDATE CustomersView SET Phone = ' 030-007xxxx' 
  WHERE CustomerID = 'ALFKI'
SELECT CustomerID, Phone FROM CustomersView 
  WHERE CustomerID = 'ALFKI'
SELECT CustomerID, Phone FROM CustomersGer 
  WHERE CustomerID = 'ALFKI'
GO