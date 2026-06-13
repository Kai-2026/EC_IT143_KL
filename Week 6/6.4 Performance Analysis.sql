--Here is our original query:

SELECT *
FROM SalesLT.Customer
WHERE LastName = 'Smith';



--Now we look at the suggestion:


/*
Missing Index Details from SQLQuery6.sql - localhost.AdventureWorksLT2022 (LAPTOP-1473TJ7O\Kydon (56))
The Query Processor estimates that implementing the following index could improve the query cost by 86.6995%.
*/

/*
USE [AdventureWorksLT2022]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [SalesLT].[Customer] ([LastName])

GO
*/


--Run the suggestion and note the time difference:
USE [AdventureWorksLT2022]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [SalesLT].[Customer] ([LastName])

GO
