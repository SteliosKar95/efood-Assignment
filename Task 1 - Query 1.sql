SELECT
  city,
  SUM(CASE WHEN cuisine = 'Breakfast' THEN amount END) / COUNT(CASE WHEN cuisine = 'Breakfast' THEN order_id END) AS breakfast_basket,
  SUM(amount) / COUNT(order_id) AS efood_basket,
  COUNT(CASE WHEN cuisine = 'Breakfast' THEN order_id END) / COUNT(DISTINCT CASE WHEN cuisine = 'Breakfast' THEN user_id END) AS breakfast_freq,
  COUNT(order_id) / COUNT(DISTINCT user_id) AS efood_freq,
  COUNT(DISTINCT CASE WHEN breakfast_order_count > 3 THEN user_id END) / COUNT(DISTINCT CASE WHEN cuisine = 'Breakfast' THEN user_id END) AS breakfast_user3freq_perc,
  COUNT(DISTINCT CASE WHEN user_order_count > 3 THEN user_id END) / COUNT(DISTINCT user_id) AS efood_user3freq_perc
FROM (
  SELECT
    *,
    COUNT(DISTINCT CASE WHEN cuisine = 'Breakfast' THEN order_id END) OVER (PARTITION BY city, user_id) AS breakfast_order_count,
    COUNT(DISTINCT order_id) OVER (PARTITION BY city, user_id) AS user_order_count
  FROM `efood2022-388712.main_assessment.orders` 
)
GROUP BY city
HAVING COUNT(order_id) > 1000
ORDER BY COUNT(CASE WHEN cuisine = 'Breakfast' THEN order_id END) DESC
LIMIT 5;
