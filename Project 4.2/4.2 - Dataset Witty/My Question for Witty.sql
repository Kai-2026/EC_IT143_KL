--S1 Question: How many ip addresses did we capture that start with 12.221?
--S2 Answer: Look at Witty_Countries table

--S3 Ad Hoc SQL query:
SELECT SUM(COUNT(IPAddress)) OVER() AS total_count
FROM [Threat Intelligence].[dbo].[Witty_Countries]
WHERE IPAddress LIKE '12.221%'

--S4 Turn query into view
DROP VIEW IF EXISTS dbo.v_Witty_Countries;
GO

CREATE VIEW dbo.v_Witty_Countries AS
SELECT SUM(COUNT(IPAddress)) OVER() AS total_count
FROM [Threat Intelligence].[dbo].[Witty_Countries]
WHERE IPAddress LIKE '12.221%'

--S5 Create a table to store view data in
DROP TABLE IF EXISTS dbo.IPAddressesCaptured
CREATE TABLE dbo.IPAddressesCaptured (
	IPs int
);
--S6 Load data from the view into the table
DELETE FROM dbo.IPAddressesCaptured
INSERT INTO dbo.IPAddressesCaptured
SELECT *
FROM dbo.v_Witty_Countries;

--S7 Turn S6 into a procedure so we don't have to manually type it out each time
CREATE PROCEDURE ReloadIPAddressesCaptured
AS
BEGIN

DELETE FROM dbo.IPAddressesCaptured
INSERT INTO dbo.IPAddressesCaptured
SELECT *
FROM dbo.v_Witty_Countries;

END;

--S8
EXEC ReloadIPAddressesCaptured