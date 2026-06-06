/** QUESTION
We need information on how extensive this is and where we need to focusour immediate attention.
Who is being targeted and what countries are being affected the most?
**/

--Which Country Recieved the most Traffic
SELECT Country, COUNT(Country) as Hits
 FROM dbo.CodeRedJuly
 GROUP BY Country
 ORDER BY Hits DESC;

--Geographically most dense areas for traffic, based on splitting all longitude and latitude into 5x5 squares

--shove everything into a 5x5 degree grid
WITH Grids AS (
SELECT
    Country,
    Latitude,
    Longitude,
    FLOOR(Latitude / 5.0) * 5 AS LatBucket,
    FLOOR(Longitude / 5.0) * 5 AS LonBucket
    FROM dbo.CodeRedJuly
),
--Counts how many get grouped into a bucket
Counts AS (
    SELECT
    Country,
    LatBucket,
    LonBucket,
    COUNT(*) AS PointCount
    FROM Grids
    GROUP BY Country, LatBucket, LonBucket
)
SELECT 
    Country,
    LatBucket,
    LonBucket,
    PointCount
FROM Counts
ORDER BY PointCount DESC


 
 /** QUESTION:
 We need to track down where this attack came from, if it was a state sponsored attack from an unfriendly nation 
 or an independent cybercriminal group. What are the earliest geographical locations where the Code Red worm was 
 first detected?
 **/
 --This method would be especially clearer if plotted out on a timeline.
 SELECT
    StartTime,
    Latitude,
    Longitude,
    Country
 FROM dbo.CodeRedJuly
 ORDER BY StartTime ASC



 /** QUESTION:
 We need to figure out the motivation behind this attack, if it was monetary gain, ideological, or a foreign 
 state attack. What percentage of affected domains are .gov sites? Is there any indication that government 
 websites were specifically targeted?
 **/


SELECT
    TopLevelDomain,
    COUNT(TopLevelDomain) AS hitsperdomain,
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS PercentOfTotal
FROM CodeRedJuly
GROUP BY TopLevelDomain
ORDER BY
    --remove this next line to see all percentages:
    CASE WHEN TopLevelDomain = 'gov' THEN 0 ELSE 1 END,
    hitsperdomain DESC
/** ANSWER:
It appears that government websites were not targetted. It mainly spread through the internet infrastructure
('.arpa') and common domains such as '.net' and '.com'
**/



/**
Could you write a query to find which country had the highest number of worm packets per hour during the first
24 hours of each outbreak? I’d love to see how you’d group by hour and country. - Sandra Chueze
**/


--Witty Stats
 WITH FirstTimestampWT AS
(
    SELECT MIN(TRY_CONVERT(DECIMAL(19,9), StartTime)) AS FirstTime
    FROM dbo.WittyTable
),
Witty AS (
    SELECT Witty_Countries.IPAddress, WittyTable.pkts, WittyTable.starttime, Witty_Countries.Country
    FROM WittyTable
    FULL JOIN Witty_Countries ON WittyTable.IPAddress=Witty_Countries.IPAddress
    CROSS JOIN FirstTimestampWT wt
    WHERE TRY_CONVERT(DECIMAL(19,9), StartTime) >= FirstTime
    AND TRY_CONVERT(DECIMAL(19,9), StartTime) < FirstTime + 86400
    ),

WittyStats AS (
    SELECT w.Country,
           COUNT(*) AS Hits
    FROM Witty w
    CROSS JOIN FirstTimestampWT wf
    WHERE TRY_CONVERT(DECIMAL(19,9), w.StartTime) >= wf.FirstTime
      AND TRY_CONVERT(DECIMAL(19,9), w.StartTime) < wf.FirstTime + 86400
    GROUP BY w.Country
    ),

 --Final Stats for CodeRed
FirstTimestamp AS
(
    SELECT MIN(TRY_CONVERT(DECIMAL(19,9), StartTime)) AS FirstTime
    FROM dbo.CodeRedJuly
),

CodeRedStats AS (
    SELECT c.Country,
           COUNT(*) AS Hits
    FROM dbo.CodeRedJuly c
    CROSS JOIN FirstTimestamp f
    WHERE TRY_CONVERT(DECIMAL(19,9), c.StartTime) >= f.FirstTime
      AND TRY_CONVERT(DECIMAL(19,9), c.StartTime) < f.FirstTime + 86400
    GROUP BY c.Country
)
SELECT WittyStats.Country ,WittyStats.Hits AS WittyHits,CodeRedStats.Hits AS CodeRedHits  FROM WittyStats
JOIN CodeRedStats ON WittyStats.Country=CodeRedStats.Country
ORDER BY WittyHits DESC