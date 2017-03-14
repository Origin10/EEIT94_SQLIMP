
--
USE master
GO
CREATE LOGIN  L1 WITH PASSWORD= 'l1'              --建 Login: L1, 密碼有分大小寫
GO

use Northwind
go
CREATE USER u1 FOR LOGIN L1                       --建 User : u1
GO
CREATE SCHEMA s1 AUTHORIZATION u1                 --建 Schema : s1
GO
ALTER USER u1 WITH DEFAULT_SCHEMA=s1              --設定 u1 預設 schema 為 s1
GO

EXEC sp_addrolemember 'db_datawriter', 'u1'       --授權 u1
GO
EXEC sp_addrolemember 'db_ddladmin'  , 'u1'
GO
EXEC sp_addrolemember 'db_datareader', 'u1'
GO




--以 L1 登入 建 表格 a1 於 northwind
use Northwind
go
create table a1(id int)
go

insert into    a1 values (101);
insert into s1.a1 values (102);

select * from     a1;
select * from  s1.a1;
select * from  dbo.a1;    --失敗
go


--刪除 反向順序
DROP TABLE  s1.a1
GO
DROP SCHEMA s1
GO
--中斷 L1 連線 (左邊 SSMS)
DROP USER u1
GO

--回另一管理者視窗 + 開啟活動監視器 (右鍵 Server名) +  終止 L1 處理程序
USE [master]
GO
DROP LOGIN L1
GO




