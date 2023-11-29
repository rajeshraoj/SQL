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