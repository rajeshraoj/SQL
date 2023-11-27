###################### 1294

SELECT
    C.country_name,
    CASE
        WHEN AVG(weather_state) <= 15 THEN 'Cold'
        WHEN AVG(weather_state) >= 25 THEN 'Hot'
        ELSE 'Warm' END Weather_type

FROM Countries C
INNER JOIN Weather W ON (C.country_id = W.country_id)
WHERE DATE_FORMAT(W.day,'%Y-%m') = '2019-11'
GROUP BY C.country_name

###  My answer does not take care of duplicates in country name, better to join based on country_id then join with main country table
# Write your MySQL query statement below
SELECT c.country_name, avg_weather.weather_type
FROM Countries as c
JOIN
(SELECT country_id, AVG(weather_state) as "avg_weather",
CASE 
    WHEN AVG(weather_state) <= 15 THEN "Cold"
    WHEN AVG(weather_state) >= 25 THEN "Hot"
    ELSE "Warm"
END as weather_type
FROM Weather
WHERE day BETWEEN "2019-11-01" AND "2019-11-30"
GROUP BY country_id) as avg_weather
ON c.country_id = avg_weather.country_id;


#######################################33 2339

SELECT
    H.team_name AS home_team,
    A.team_name AS away_team
FROM Teams H
CROSS JOIN Teams A
WHERE H.team_name != A.team_name

############################################### 2142

SELECT
    B.bus_id,
    COUNT(X.passenger_id) passengers_cnt
FROM Buses B
LEFT OUTER JOIN (
SELECT
    P.passenger_id,
    min(B.arrival_time) bus_arrival_time
FROM Buses B
CROSS JOIN Passengers P
WHERE P.arrival_time <= B.arrival_time
GROUP BY P.passenger_id ) X
ON (B.arrival_time = X.bus_arrival_time)
GROUP BY 1
ORDER BY 1

#################3333 1988

WITH cte AS (
SELECT
    school_id,
    max(student_count),
    min(score) score
FROM Schools
CROSS JOIN Exam
WHERE capacity >= student_count
GROUP BY school_id)
SELECT
    S.school_id,
    coalesce(cte.score,-1) score
FROM Schools S LEFT OUTER JOIN cte on(S.school_id = cte.school_id)