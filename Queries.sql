--  -----------------------------Query1-------------------------------


WITH Month1 AS (
    SELECT v.iso_code,
           l.location AS [Country Name (CN)],
           SUM(v.daily_vaccinations) AS [Administered Vaccine on OM1 (VOM1)]
      FROM vaccinations v
           JOIN
           location l ON v.iso_code = l.iso_code
     WHERE v.date LIKE '%04-2022'
     GROUP BY v.iso_code,
              l.location
),
Month2 AS (
    SELECT v.iso_code,
           l.location AS [Country Name (CN)],
           SUM(v.daily_vaccinations) AS [Administered Vaccine on OM2 (VOM2)]
      FROM vaccinations v
           JOIN
           location l ON v.iso_code = l.iso_code
     WHERE v.date LIKE '%05-2022'
     GROUP BY v.iso_code,
              l.location
)
SELECT 'April 2022' AS [Observation Months 1 (OM1)],
       m1.[Country Name (CN)],
       m1.[Administered Vaccine on OM1 (VOM1)],
       'May 2022' AS [Observation Months 2 (OM2)],
       COALESCE(m2.[Administered Vaccine on OM2 (VOM2)], 0) AS [Administered Vaccine on OM2 (VOM2)],
       (m1.[Administered Vaccine on OM1 (VOM1)] - COALESCE(m2.[Administered Vaccine on OM2 (VOM2)], 0) ) AS [Difference of totals (VOM1 - VOM2)]
  FROM Month1 m1
       LEFT JOIN
       Month2 m2 ON m1.iso_code = m2.iso_code;
       
       
--  ----------------------------------Query2-------------------------------------


WITH MonthlyCumulative AS (
    SELECT
        v.iso_code,
        l.location AS "Country Name",
        strftime('%m/%Y', substr(v.date, 7, 4) || '-' || substr(v.date, 4, 2) || '-' || substr(v.date, 1, 2)) AS "Month",
        SUM(v.daily_vaccinations) AS "Cumulative Doses"
    FROM
        vaccinations v
    JOIN
        location l ON v.iso_code = l.iso_code
    GROUP BY
        v.iso_code, l.location, strftime('%m/%Y', substr(v.date, 7, 4) || '-' || substr(v.date, 4, 2) || '-' || substr(v.date, 1, 2))
),

MonthlyAverage AS (
    SELECT
        "Month",
        AVG("Cumulative Doses") AS "Average Doses"
    FROM
        MonthlyCumulative
    GROUP BY
        "Month"
)


SELECT
    mc."Country Name",
    mc."Month",
    mc."Cumulative Doses"
FROM
    MonthlyCumulative mc
JOIN
    MonthlyAverage ma ON mc."Month" = ma."Month"
WHERE
    mc."Cumulative Doses" > ma."Average Doses";


-- ---------------------------Query3----------------------------------------


SELECT v.vaccineName AS [Vaccine Type],
       l.location AS Country
  FROM location_vaccine lv
       JOIN
       vaccine v ON lv.vaccineID = v.vaccineID
       JOIN
       location l ON lv.iso_code = l.iso_code;
       

-- --------------------------------------Query4------------------------------


SELECT l.location AS [Country Name],
       s.source_website AS [Source Name (URL)],
       max(v.total_vaccinations) AS [Total Administered Vaccine]
  FROM location l
       INNER JOIN
       Vaccinations v ON l.iso_code = v.iso_code
        INNER JOIN
       Source s ON l.sourceID = s.sourceID
 GROUP BY l.iso_code,s.source_website;
 

-- ----------------------------------------Query5-------------------------------------


SELECT t1.[Date Range (Months)],
       COALESCE(t1.total_fully_vaccinated, 0) AS [United States],
       COALESCE(t2.total_fully_vaccinated, 0) AS Wales,
       COALESCE(t3.total_fully_vaccinated, 0) AS Canada,
       COALESCE(t4.total_fully_vaccinated, 0) AS Denmark
  FROM (
           SELECT SUBSTR(v.date, 7, 4) || '-' || SUBSTR(v.date, 4, 2) AS [Date Range (Months)],
                  MAX(v.people_fully_vaccinated) AS total_fully_vaccinated
             FROM vaccinations v
                  JOIN
                  location l ON v.iso_code = l.iso_code
            WHERE SUBSTR(v.date, 7, 4) IN ('2022', '2023') AND 
                  l.location = 'United States'
            GROUP BY "Date Range (Months)"
       )
       t1
       LEFT JOIN
       (
           SELECT SUBSTR(v.date, 7, 4) || '-' || SUBSTR(v.date, 4, 2) AS [Date Range (Months)],
                  MAX(v.people_fully_vaccinated) AS total_fully_vaccinated
             FROM vaccinations v
                  JOIN
                  location l ON v.iso_code = l.iso_code
            WHERE SUBSTR(v.date, 7, 4) IN ('2022', '2023') AND 
                  l.location = 'Wales'
            GROUP BY "Date Range (Months)"
       )
       t2 ON t1.[Date Range (Months)] = t2.[Date Range (Months)]
       LEFT JOIN
       (
           SELECT SUBSTR(v.date, 7, 4) || '-' || SUBSTR(v.date, 4, 2) AS [Date Range (Months)],
                  MAX(v.people_fully_vaccinated) AS total_fully_vaccinated
             FROM vaccinations v
                  JOIN
                  location l ON v.iso_code = l.iso_code
            WHERE SUBSTR(v.date, 7, 4) IN ('2022', '2023') AND 
                  l.location = 'Canada'
            GROUP BY "Date Range (Months)"
       )
       t3 ON t1.[Date Range (Months)] = t3.[Date Range (Months)]
       LEFT JOIN
       (
           SELECT SUBSTR(v.date, 7, 4) || '-' || SUBSTR(v.date, 4, 2) AS [Date Range (Months)],
                  MAX(v.people_fully_vaccinated) AS total_fully_vaccinated
             FROM vaccinations v
                  JOIN
                  location l ON v.iso_code = l.iso_code
            WHERE SUBSTR(v.date, 7, 4) IN ('2022', '2023') AND 
                  l.location = 'Denmark'
            GROUP BY "Date Range (Months)"
       )
       t4 ON t1.[Date Range (Months)] = t4.[Date Range (Months)]
 ORDER BY t1.[Date Range (Months)];