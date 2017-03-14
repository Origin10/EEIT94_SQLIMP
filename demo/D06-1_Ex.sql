/*
** This file contains examples from Module6: 'Planning 
** Indexes'
** To use the file, highlight and execute each example.
*/

USE credit
GO

/*
** Determining Selectivity
**
** Theses examples demonstrate differences in selectivity 
*/
SELECT * 
FROM member
WHERE member_no > 8999

SELECT *
FROM member
WHERE member_no > 9001

SELECT * 
FROM member
WHERE member_no < 9001

/*
** Determining Density
** Note: These names match the slide but do not
** exist in the member table.
*/
SELECT *
FROM member
WHERE lastname = 'Randall'

SELECT *
FROM member
WHERE lastname = 'Ota'

/*
** Determining Distribution of Data
** This example is uses a general reference 
** to "column" and cannot be executed.

SELECT column, count(*) AS 'Data Count'
FROM table
GROUP BY column
ORDER BY 'Data count' DESC
*/

