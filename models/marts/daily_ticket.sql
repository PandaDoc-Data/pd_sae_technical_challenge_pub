{{ config(
    materialized='table',
    schema='ANALYTICS'  
) }}

WITH tickets AS (
  SELECT
    DATE_TRUNC('day', event_time) AS date
    , user_id
    , user_session
    , SUM(price) AS ticket_value
  FROM {{ source('analytics', 'event_clean') }}
  WHERE event_type = 'purchase'
  GROUP BY ALL
)

SELECT
  date::date AS date
  , SUM(ticket_value) AS total_sales
  , MIN(ticket_value) AS min_ticket
  -- change the column name, avoiding column name start with number
  , PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ticket_value) AS perc_25th_ticket
  , PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY ticket_value) AS perc_50th_ticket
  , PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ticket_value) AS perc_75th_ticket
  , MAX(ticket_value) AS max_ticket
FROM tickets
GROUP BY 1 
