SELECT
    D.dept_name,
    COALESCE(COUNT(student_id)) student_number
FROM department D
LEFT OUTER JOIN Student S ON (D.dept_id = S.dept_id)
GROUP BY 1
ORDER BY 2 DESC,1

SELECT dept_name, SUM(CASE WHEN s.dept_id THEN 1 ELSE 0 END) as student_number
FROM department d LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY 1
ORDER BY 2 desc, 1g

#################################### 2112
WITH F1 AS
(SELECT
    departure_airport airport,
    SUM(flights_count) dfc
FROM Flights
GROUP BY 1),
F2 AS (SELECT
    arrival_airport airport,
    SUM(flights_count) afc
FROM Flights
GROUP BY 1),
cte AS (
SELECT 
    F1.airport,
    coalesce(dfc,0) + coalesce(afc,0) cnt
FROM F1 LEFT OUTER JOIN F2 ON (F1.airport = F2.airport)
UNION
SELECT 
    F2.airport,
    coalesce(dfc,0) + coalesce(afc,0) cnt
FROM F1 RIGHT OUTER JOIN F2 ON (F1.airport = F2.airport))
SELECT airport as airport_id FROM cte WHERE cnt = (select max(cnt) from cte)

WITH CTE AS (
  SELECT airport_id, RANK() OVER(ORDER BY SUM(flights_count) DESC) AS RN
  FROM ( SELECT departure_airport AS airport_id, flights_count FROM Flights
           UNION ALL
       SELECT arrival_airport AS airport_id, flights_count FROM Flights ) T
  GROUP BY airport_id )

SELECT airport_id FROM CTE WHERE RN = 1


###################################### 1445

# Write your MySQL query statement below
SELECT
    A.sale_date,
    app_num - orj_num diff
FROM 
(SELECT
    sale_date,
    sold_num as app_num
FROM Sales
WHERE fruit = 'apples'
GROUP BY 1) A 
INNER JOIN (SELECT
                sale_date,
                sold_num as orj_num
            FROM Sales
            WHERE fruit = 'oranges'
            GROUP BY 1) O 
ON A.sale_date = O.sale_date