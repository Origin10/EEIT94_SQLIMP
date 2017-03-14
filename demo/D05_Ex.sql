
-- *** NOTE: The objects below may already exist. You may need to delete the object first.

/*
**  This file contains examples from 'Module 5: Implementing Data Integrity'.
**  To use the file, highlight and execute each example.
**
**  Defining Constraints
**
**  Example
**  This example creates an Products table and defines all of
**  the Product Constraints. 
*/
USE ClassNorthwind
GO
CREATE TABLE dbo.Products
(
   ProductID	int IDENTITY (1, 1) NOT NULL ,
   ProductName	nvarchar (40) NOT NULL ,
   SupplierID	int 	      NULL ,
   CategoryID	int 	      NULL ,
   QuantityPerUnit nvarchar (20) NULL ,
   UnitPrice	money	      NULL     CONSTRAINT DF_Products_UnitPrice    DEFAULT(0),
   UnitsInStock	smallint      NULL     CONSTRAINT DF_Products_UnitsInStock DEFAULT(0),
   UnitsOnOrder	smallint      NULL     CONSTRAINT DF_Products_UnitsOnOrder DEFAULT(0),
   ReorderLevel	smallint      NULL     CONSTRAINT DF_Products_ReorderLevel DEFAULT(0),
   Discontinued	bit	      NOT NULL CONSTRAINT DF_Products_Discontinued DEFAULT(0),
	
CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (ProductID),

CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID)
	REFERENCES dbo.Categories (CategoryID) ON UPDATE CASCADE,
CONSTRAINT FK_Products_Suppliers  FOREIGN KEY (SupplierID)
	REFERENCES dbo.Suppliers (SupplierID)  ON DELETE CASCADE,

CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
CONSTRAINT CK_ReorderLevel 	 CHECK (ReorderLevel >= 0),
CONSTRAINT CK_UnitsInStock 	 CHECK (UnitsInStock >= 0),
CONSTRAINT CK_UnitsOnOrder 	 CHECK (UnitsOnOrder >= 0)
)
GO

-- Show the constraints that exist on the Products table.
EXEC sp_helpconstraint [dbo.products]

-- Show the Referencial constraints that exist.
SELECT * FROM information_schema.referential_constraints

/*
**  DEFAULT Constraints
**
**  Example
**  This example adds a DEFAULT constraint that inserts the UNKNOWN value 
**  in the Customers table if a contact name is not provided.
*/
USE ClassNorthwind
GO
ALTER TABLE dbo.Customers
   ADD CONSTRAINT DF_contactname DEFAULT 'UNKNOWN' FOR ContactName


/*
**  CHECK Constraints
**
**  Example
**  This example adds a CHECK constraint to ensure
**  that a birth date conforms to an acceptable date.
*/
USE ClassNorthwind
GO
ALTER TABLE dbo.Employees
   ADD CONSTRAINT CK_birthdate
   CHECK (BirthDate > '01-01-1900' AND BirthDate < getdate())

/*
**  This DBCC statement is used to see what rows violate the check
**  constraint and return the voilating rows in a result set.
*/
DBCC CHECKCONSTRAINTS (CK_birthdate)
GO


/*
**  PRIMARY KEY Constraints
**
**  Example
**  This example adds a constraint that specifies that the primary key 
**  value of the Customers table is the Customer ID and indicates that a 
**  nonclustered index will be created to enforce the constraint.
*/
USE ClassNorthwind
GO
ALTER TABLE dbo.Customers ADD CONSTRAINT PK_Customers PRIMARY KEY NONCLUSTERED (CustomerID)
GO

/*
**  UNIQUE Constraints
**
**  Example
**  This example creates a UNIQUE constraint on the
**  company name in the Suppliers table.
*/
USE ClassNorthwind
GO
ALTER TABLE dbo.Suppliers ADD CONSTRAINT U_CompanyName UNIQUE NONCLUSTERED (CompanyName)
GO

/*
**  FOREIGN KEY Constraints
**
**  Example 1
**  This example uses a FOREIGN KEY constraint to ensure that
**  any orders are associated with a valid customer. 
*/
USE ClassNorthwind
GO
ALTER TABLE dbo.Orders ADD CONSTRAINT FK_Orders_Customers
   FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
GO

/*
**  Example 2
**  This example adds constraints that restricts the
**  value for ReportsTo to a valid employee ID. 
*/
USE ClassNorthwind
GO
ALTER TABLE dbo.Employees ADD CONSTRAINT FK_Employees_Employees
   FOREIGN KEY (ReportsTo) REFERENCES dbo.Employees(EmployeeID)
GO

/*
**  Disabling Constraint Checking on Existing Data
**
**  Example
**  In this example, you add a CHECK constraint that restricts
**  the value for ReportsTo to a valid employee ID. 
**  The constraint is not enforced on existing data.
*/
USE Northwind
ALTER TABLE dbo.Employees WITH NOCHECK
   ADD CONSTRAINT FK_Employees_Employees
   FOREIGN KEY (ReportsTo) REFERENCES dbo.Employees(EmployeeID)


/*
**  Disabling Constraint Checking When Loading New Data
**
**  Example
**  This example disables the FK_Employees_Employees constraint. It can be
**  reenabled by executing another ALTER TABLE statement with the CHECK clause. 
*/
USE Northwind
ALTER TABLE dbo.Employees NOCHECK
   CONSTRAINT FK_Employees_Employees
   
SELECT OBJECTPROPERTY(OBJECT_ID('FK_Employees_Employees'), 'CnstIsDisabled') 
ALTER TABLE dbo.Employees CHECK
   CONSTRAINT FK_Employees_Employees
GO


/*
**  Binding a Default
**
**  Example
**  This example inserts a placeholder phone number in the correct format
**  until the actual phone number can be supplied.
**  Ficticious example; will not execute.
*/
USE Northwind
GO
CREATE DEFAULT phone_no_default
   AS '(000)000-0000'
GO
EXEC sp_bindefault phone_no_default, 'Customers.phone'

/*
**  Binding a Rule
**
**  Example
**  In this example, the rule ensures that only specified states are allowed.
**  Ficticious example; will not execute.
*/
USE Northwind
GO
CREATE RULE regioncode_rule
   AS @regioncode IN('IA','IL','KS','MO')
GO
EXEC sp_bindrule regioncode_rule, 'Customers.Region'


-- End of File
