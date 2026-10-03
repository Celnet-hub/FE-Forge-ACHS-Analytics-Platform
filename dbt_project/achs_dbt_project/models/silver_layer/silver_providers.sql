{{ config(materialized='table') }}

WITH raw_data AS (
    SELECT raw_json, loaded_at FROM {{ source('achs_raw', 'PROVIDERS_RAW') }}
),

extracted_json AS (
    SELECT
        raw_json:provider_id::VARCHAR AS provider_id,
        raw_json:npi_number::VARCHAR AS npi_number,
        raw_json:provider_type::VARCHAR AS provider_type,
        raw_json:specialty_code::VARCHAR AS specialty_code,
        raw_json:facility_id::VARCHAR AS facility_id,
        {{ convert_to_boolean('raw_json:is_active::VARCHAR') }} AS is_active,
        raw_json:hire_date::DATE AS hire_date,
        loaded_at
    FROM raw_data
),

count_extracted AS (
    SELECT COUNT(*) AS total FROM extracted_json
),

deduplicated AS (
    SELECT * FROM extracted_json
    QUALIFY ROW_NUMBER() OVER (PARTITION BY provider_id ORDER BY loaded_at DESC) = 1
),

count_deduplicated AS (
    SELECT COUNT(*) AS total FROM deduplicated
)

SELECT * FROM deduplicated