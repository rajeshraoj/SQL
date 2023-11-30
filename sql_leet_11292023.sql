WITH child_count AS (
    SELECT
        p_id,
        COUNT(*) child_cnt
    FROM Tree
    GROUP BY p_id
)
SELECT id,
        CASE
            WHEN T.p_id IS NULL THEN 'Root'
            WHEN child_count.p_id IS NULL THEN 'Leaf'
            ELSE 'Inner' END type FROM Tree T
LEFT OUTER JOIN child_count ON (T.id = child_count.p_id)

WITH cte AS (
SELECT
    user_id,
    visit_date,
    DATEDIFF(COALESCE(LEAD(visit_date,1) OVER(PARTITION BY user_id ORDER BY visit_date),'2021-01-01'),visit_date) biggest_window
FROM UserVisits)
SELECT 
    user_id,
    max(biggest_window) AS biggest_window
FROM cte
GROUP BY user_id