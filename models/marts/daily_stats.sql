{{ config(
    materialized='table',
    schema='ANALYTICS'  
) }}

WITH base AS (
    SELECT
        DATE_TRUNC('day', event_time) AS date
        , user_id
        , user_session
        , event_type
    FROM {{ source('analytics', 'event_clean') }}
)

SELECT
    date::date AS date
    -- All users who had any event
    , COUNT(DISTINCT user_id) AS visitors
    -- All sessions
    , COUNT(DISTINCT user_session) AS sessions

    -- Views (event_type = 'view')
    , COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS viewers
    , SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS views

    -- Adds to cart (event_type = 'cart')
    , COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END) AS leaders
    , SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS leads

    -- Purchases (event_type = 'purchase')
    , COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchasers
    , SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases

FROM base
GROUP BY 1
