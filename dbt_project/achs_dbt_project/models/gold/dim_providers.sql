{{ config(
    materialized='table',
    schema='gold',
    cluster_by=['specialty_code', 'facility_id']
) }}

WITH silver_providers AS (
    SELECT * FROM {{ ref('silver_providers') }}
),

dim_providers AS (
    SELECT
        provider_id,
        npi_number,
        provider_type,
        specialty_code,
        facility_id,
        is_active,
        hire_date
    FROM silver_providers
)

SELECT * FROM dim_providers