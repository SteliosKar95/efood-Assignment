SELECT
  city,
  ROUND(SUM(CASE WHEN row_num <= 10 THEN order_count ELSE 0 END) * 100.0 / SUM(order_count), 2) AS top_10_orders_percentage
FROM (
  SELECT
    city,
    COUNT(*) AS order_count,
    ROW_NUMBER() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS row_num
  FROM
    efood2022-388712.main_assessment.orders
  GROUP BY
    city,
    user_id
)
GROUP BY
  city
ORDER BY
  city;
  