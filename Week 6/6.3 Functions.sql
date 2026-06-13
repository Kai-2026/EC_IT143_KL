--How to extract the first name from the contact name.

--Answer: Split the string into two different parts with the space as the delimiter


--Ad Hoc Solution
SELECT [ContactName],
       LEFT([ContactName],CHARINDEX(' ',[ContactName] + ' ')-1)  AS FIRST_NAME,
       SUBSTRING([ContactName],CHARINDEX(' ',[ContactName] + ' ')+1,LEN([ContactName])) AS LAST_NAME
FROM   [t_w3_schools_customers]




--Function: first_name
--Purpose: extract first name from format 'First Last'
CREATE OR ALTER FUNCTION first_name (
    @ContactName varchar(50)
)
RETURNS varchar(25)
AS
BEGIN
    DECLARE @FirstName varchar(25);
    SET @FirstName =
       LEFT(@ContactName,CHARINDEX(' ',@ContactName + ' ')-1)
    RETURN @FirstName;
END;


--CTE 0 results expected
WITH s1 
AS (
SELECT LEFT([ContactName],CHARINDEX(' ',[ContactName] + ' ')-1)  AS FirstName1,
       dbo.first_name(ContactName) AS FirstName2
FROM   [t_w3_schools_customers]

)
SELECT * FROM s1
WHERE FirstName1 <> FirstName2


--Function: last_name
--Purpose: extract last name from format 'First Last'

CREATE OR ALTER FUNCTION last_name (
    @ContactName varchar(50)
)
RETURNS varchar(25)
AS
BEGIN
    DECLARE @LastName varchar(25);
    SET @LastName =
       SUBSTRING(@ContactName,CHARINDEX(' ',@ContactName + ' ')+1,LEN(@ContactName))
    RETURN @LastName;
END;


--CTE 0 results expected
WITH s1 
AS (
SELECT SUBSTRING([ContactName],CHARINDEX(' ',[ContactName] + ' ')+1,LEN([ContactName])) AS LastName1,
       dbo.last_name(ContactName) AS LastName2
FROM   [t_w3_schools_customers]

)
SELECT * FROM s1
WHERE LastName1 <> LastName2