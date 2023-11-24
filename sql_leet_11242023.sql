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

##### Super

select sale_date, sum(if(fruit='apples', sold_num, 0)) -  sum(if(fruit='oranges', sold_num, 0))  as diff
from sales
group by sale_date

################### 534

SELECT
    player_id,
    event_date,
    SUM(games_played) OVER(PARTITION BY player_id ORDER BY event_date) games_played_so_far
FROM Activity

#######################3 2228

WITH cte AS (
SELECT
    *,
    IF(DATEDIFF(LEAD(purchase_date,1) OVER(PARTITION BY user_id ORDER BY purchase_date),purchase_date) <= 7,1,0)  sel
FROM Purchases)
SELECT
    DISTINCT user_id
FROM cte WHERE sel = 1
ORDER BY 1

########### Using Self Join
select distinct p1.user_id
from purchases p1
inner join
purchases p2
on p1.user_id=p2.user_id and p1.purchase_id<>p2.purchase_id
and abs(datediff(p1.purchase_date, p2.purchase_date))<=7
order by p1.user_id


######################  1132

WITH cte AS (
SELECT 
 *
FROM (
SELECT
 post_id,
 action_date
FROM Actions
WHERE action = 'report' and extra = 'spam') A
LEFT OUTER JOIN (
    SELECT post_id as rem
    FROM Removals
) B ON (A.post_id = B.rem)),
cte2 as (
SELECT
    count(distinct rem)/COUNT(distinct post_id) cnt from cte
    group by action_date)
SELECT round(avg(cnt)*100,2) average_daily_percent from cte2


#################################### 1098

select b.book_id, b.name
from books b left join
    (select book_id, sum(quantity) as book_sold
    from Orders 
    where dispatch_date between '2018-06-23' and '2019-06-23'
    group by book_id) t
on b.book_id = t.book_id
where available_from < '2019-05-23'
and (book_sold is null or book_sold <10)
order by b.book_id;


######################## 2308

WITH cte AS (
SELECT
    user_id,
    gender,
    CASE 
        WHEN gender='female' then 1 
        WHEN gender='male'  then 3
        ELSE 2 END ordr,
    RANK() OVER(partition by gender order by user_id) rnk
FROM Genders
)
SELECT 
    user_id,
    gender
FROM cte
ORDER BY rnk, ordr
