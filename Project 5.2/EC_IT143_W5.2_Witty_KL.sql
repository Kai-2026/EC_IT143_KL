/** Question #1
We need a picture of the scope of the attack and where to concentrate our immediate attention. What IP Addresses
are showing up as infected and what are their hostnames? Are there any hostnames that are being targeted more 
than others?
**/

SELECT COUNT(IPAddress) AS NumofIPs, HostName FROM Witty_Stage2
GROUP BY HostName
/** Answer
From our data we only have recorded one ip per hostname, as far as we can tell there is no specific domain being targetted.
**/


/** Question #2
We need to compare previous threats to this one to know what to tell our stakeholders. What is the duration
difference between the Witty worm and Code Red worm?
**/
SELECT
(SELECT AVG(TRY_CONVERT(DECIMAL(18,9), endtime)-TRY_CONVERT(DECIMAL(18,9), starttime)) FROM CodeRedJuly) AS RedDuration, 
(SELECT AVG(TRY_CONVERT(INT, endtime)-TRY_CONVERT(INT, starttime)) FROM WittyTable) AS Wittyduration

/** Question #3
We need analysis information to better identify malicious traffic traveling through our networks.
How much traffic in packets and bytes did Witty generate over the internet?
**/

SELECT SUM(TRY_CONVERT(BIGINT,pkts)) AS TotalPackets,SUM(TRY_CONVERT(BIGINT,bytes))/ 1000000000 AS TotalGB FROM dbo.WittyTable


/** Question #4
What countries did the Witty and Code Red worm affect the most? Is there any correlation that suggests the
attacks might have originated form the same threat actors?
**/
 WITH CodeRed AS (
    SELECT TOP 10
        Country,
        COUNT(*) AS CodeRedHits
    FROM dbo.CodeRedJuly
    GROUP BY Country
    ORDER BY COUNT(*) DESC
),
Witty AS (
    SELECT TOP 10
        wc.Country,
        SUM(wt.pkts) AS WittyHits
    FROM WittyTable wt
    FULL JOIN Witty_Countries wc
        ON wt.IPAddress = wc.IPAddress
    GROUP BY wc.Country
    ORDER BY SUM(wt.pkts) DESC
)
SELECT *
FROM CodeRed
FULL JOIN Witty
    ON CodeRed.Country = Witty.Country;