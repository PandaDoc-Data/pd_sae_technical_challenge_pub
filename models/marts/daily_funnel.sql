{{ config(
    materialized='table',
    schema='ANALYTICS' 
) }}

WITH daily_stats AS (
    SELECT *
    FROM {{ ref('daily_stats') }}
)

SELECT
    date
    , visitors
    , viewers
    , leaders
    , purchasers
    , CASE WHEN visitors = 0 THEN 0 ELSE viewers::float / visitors END AS visitor_to_viewer
    , CASE WHEN viewers = 0 THEN 0 ELSE leaders::float / viewers END AS viewer_to_leader
    , CASE WHEN leaders = 0 THEN 0 ELSE purchasers::float / leaders END AS leader_to_purchaser
FROM daily_stats
da