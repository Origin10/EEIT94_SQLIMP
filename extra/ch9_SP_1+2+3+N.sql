
--1+2+3...+10

create function f11 ( @v int)
returns int
as
begin
DECLARE @n int,
        @s  int,
		@str  varchar(2000)

SET @n=1;
set @s = 0
set @str = ''

WHILE ( @n <= @v )
  BEGIN
    --PRINT 'n= '+ CAST(@n AS varchar(3));
	set @s = @s  + @n
	if @n< @v
	  set @str = @str + CAST(@n AS varchar(3))  + ' + '
    else
	  set @str = @str + CAST(@n AS varchar(3))  + ' = '

    SET @n = @n + 1 ;   --或 SET @n += 1; 
  END

 --PRINT 'S= '+ CAST(@s AS varchar(4));
 --PRINT  @str +  CAST(@s AS varchar(4));
 return @s
end

-- run
-- exec  p11  10

select  dbo.f11(100)

