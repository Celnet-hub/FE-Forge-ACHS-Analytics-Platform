{{ config(
    materialized='table',
    schema='gold',
    cluster_by=['date_key']
) }}

WITH date_spine AS (
    -- Generates 10,000 rows of consecutive dates starting from 2020-01-01
    SELECT 
        DATEADD(
            'day', 
            ROW_NUMBER() OVER (ORDER BY NULL) - 1, 
            '2020-01-01'::DATE
        ) AS calendar_date
    FROM TABLE(GENERATOR(ROWCOUNT => 10000))
),

dim_date_calculated AS (
    SELECT
        -- The Integer PK matching your Fact tables (e.g., 20231025)
        TO_VARCHAR(calendar_date, 'YYYYMMDD')::NUMBER AS date_key,
        calendar_date,
        TO_VARCHAR(calendar_date, 'MMMM') AS month_name,
        EXTRACT(YEAR FROM calendar_date) AS year
        
    FROM date_spine
)

SELECT * FROM dim_date_calculated