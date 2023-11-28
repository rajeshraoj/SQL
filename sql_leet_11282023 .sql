WITH cte AS (
SELECT
    P.product_name,
    P.product_id,
    RANK() OVER(PARTITION BY p.product_id ORDER BY order_date DESC) rnk,
    O.order_id,
    O.order_date
FROM Products P
INNER JOIN Orders O ON (P.product_id = O.Product_id))
SELECT product_name, product_id, order_id, order_date FROM cte
where rnk = 1
ORDER BY 1,2,3