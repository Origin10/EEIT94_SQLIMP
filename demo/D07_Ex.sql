/*
** This file contains examples from Module 8: 
** "Implementing Views"
** To use the file, highlight and execute each example.
*/

USE Northwind
GO

/*
**  Introduction to Views.
*/
CREATE VIEW dbo.EmployeeView
AS 
SELECT LastName, Firstname
FROM Employees
GO

SELECT * from EmployeeView 
GO

/*
**  Creating Views.
*/
CREATE VIEW dbo.OrderSubtotals (OrderID, Subtotal)
AS
SELECT OD.OrderID,
   SUM(CONVERT
    (money,(OD.UnitPrice*Quantity*(1-  Discount)/100))*100)
FROM [Order Details] OD
GROUP BY OD.OrderID
GO

SELECT * FROM OrderSubtotals 
go

/*
**  Example: View of Joined Tables.
*/
CREATE VIEW ShipStatusView
AS
SELECT OrderID, ShippedDate, ContactName
FROM Customers c INNER JOIN Orders o
   ON c.CustomerID = O.CustomerID
WHERE RequiredDate < ShippedDate
go
SELECT * FROM ShipStatusView 
go

/*
**  Altering and Dropping Views.
*/
ALTER VIEW dbo.EmployeeView
AS 
SELECT LastName, FirstName, Extension
FROM Employees
go

SELECT * from  dbo.EmployeeView
go

/*
**  Hiding View Definitions.
*/
CREATE VIEW dbo.[Order Subtotals]
   WITH ENCRYPTION
AS
SELECT OrderID,
 Sum(CONVERT(money,(UnitPrice*Quantity*(1-Discount)/100))*100)
   AS Subtotal
FROM [Order Details]
GROUP BY OrderID
go
--test
select * from dbo.[Order Subtotals]
go

--sp_helptext dbo.[Order Subtotals] 加 dbo schema 語法錯
--物件 'Order Subtotals' 的文字已加密。

sp_helptext [Order Subtotals]
go

exec sp_depends [Order Subtotals]


--with check option 範例
use northwind
go

IF OBJECT_ID ('v3', 'V') IS NOT NULL
  DROP VIEW v3 ;
go

create view v3
as
select * from Employees
where City = 'London'
with check option
go
select * from v3

update v3 set city = 'Taipei' where employeeid = 5

/*
訊息 550，層級 16，狀態 1，行 2
嘗試插入或更新已經失敗，因為目標檢視指定了 WITH CHECK OPTION 或跨越指定了 WITH CHECK OPTION 的檢視，而該作業產生的一個或多個資料列在 CHECK OPTION 條件約束下並不合格。
陳述式已經結束。

*/


--Extra


/*
**  Performance Considerations.
*/
go
CREATE VIEW dbo.TotalPurchaseView
AS
SELECT CompanyName, Sum(CONVERT(money,
   (UnitPrice*Quantity*(1-Discount)/100))*100) AS Subtotal
FROM Customers c INNER JOIN Orders o
     ON c.CustomerID=o.CustomerID
   INNER JOIN [Order Details] od
     ON o.OrderID = od.OrderID
GROUP BY CompanyName
GO

CREATE VIEW dbo.TopSalesView
AS
SELECT *
FROM dbo.TotalPurchaseView
WHERE Subtotal > 50000
GO

SELECT *
FROM dbo.TopSalesView
WHERE CompanyName = 'Ernst Handel'


GO
