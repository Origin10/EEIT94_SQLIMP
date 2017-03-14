--check 
--例 1
create table ck1
(  id int ,
   qty  int  check (qty >=10)
  )

--ok
insert into ck1 values(101, 25)

--not ok
insert into ck1 values(102, 5)

/*
訊息 547，層級 16，狀態 0，行 1
INSERT 陳述式與 CHECK 條件約束 "CK__ck1__qty__1367E606" 衝突。衝突發生在資料庫 "sample2"，資料表 "dbo.ck1", column 'qty'。
陳述式已經結束。
*/

--例 2 加 Constraint name
create table ck11
(  id int ,
   qty  int  constraint ck_ck_11_greater_than_10 check (qty >=10)
)
go

--not ok
insert into ck11 values(102, 5)

/*
訊息 547，層級 16，狀態 0，行 2
INSERT 陳述式與 CHECK 條件約束 "ck_ck_11_greater_than_10" 衝突。衝突發生在資料庫 "sample2"，資料表 "dbo.ck11", column 'qty'。
陳述式已經結束。
*/


--查詢 check 設定
sp_help ck1


--on update cascade

create table cust5
(  id int     primary key
)

create table ord5
(ono int primary key,
 id  int foreign key references cust5(id) ON UPDATE CASCADE
) 

insert into cust5 values(101)
insert into cust5 values(102)
insert into cust5 values(103)

insert into ord5 values(1, 101)
insert into ord5 values(2, 101)
insert into ord5 values(3, 102)

select * from cust5
select * from ord5

--test

delete from cust5 where id = 101
update cust5 set id = 901 where id = 101

select * from cust5
select * from ord5


