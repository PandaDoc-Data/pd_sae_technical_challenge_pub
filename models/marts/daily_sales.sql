{{
  config(
    materialized='table',
    schema='ANALYTICS'  
  )
}}

WITH purchases AS (
  SELECT
    DATE_TRUNC('day', event_time) AS date
    , price
  FROM {{ source('analytics', 'event_clean') }}
  WHERE event_type = 'purchase'
)

SELECT
  date::date AS date
  , SUM(price) AS total_sales
FROM purchases
GROUP BY 1
