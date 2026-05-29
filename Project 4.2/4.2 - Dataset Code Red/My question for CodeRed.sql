--S1 Question: What country recieved the most CodeRed traffic?

--S2 Answer: Look at dbo.CodeRedJuly

--S3 Ad Hoc SQL query:
 SELECT Country, COUNT(Country) as Hits
 FROM dbo.CodeRedJuly
 GROUP BY Country
 ORDER BY Hits DESC

--S4 Turn query into view
DROP VIEW IF EXISTS dbo.v_MostAffectedCountries ;
GO

CREATE VIEW dbo.v_MostAffectedCountries AS
 SELECT Country, COUNT(Country) as Hits
 FROM dbo.CodeRedJuly
 GROUP BY Country
--S5 Create a table to store view data in
DROP TABLE IF EXISTS MostAffectedCountries
CREATE TABLE MostAffectedCountries (
	Countries varchar(3),
	Hits int
);
--S6 Load data from the view into the table
INSERT INTO dbo.MostAffectedCountries
SELECT *
FROM dbo.v_MostAffectedCountries;
--S7 Turn S6 into a procedure so we don't have to manually type it out each time
CREATE PROCEDURE ReloadMostAffectedCountries
AS
BEGIN

DELETE FROM dbo.MostAffectedCountries
INSERT INTO dbo.MostAffectedCountries
SELECT *
FROM dbo.v_MostAffectedCountries;

END;

--S8
EXEC ReloadMostAffectedCountries;