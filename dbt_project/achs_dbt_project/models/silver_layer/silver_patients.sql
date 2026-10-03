{{ config(
    materialized='table'
) }}

WITH raw_data AS (
    SELECT 
        raw_json,
        loaded_at
    FROM {{ source('achs_raw', 'PATIENTS_RAW') }}
),

extracted_json AS (
    SELECT
        raw_json:patient_id::VARCHAR AS patient_id,
        raw_json:first_name::VARCHAR AS first_name,
        raw_json:last_name::VARCHAR AS last_name,
        raw_json:date_of_birth::DATE AS date_of_birth,
        raw_json:contact_info:email::VARCHAR AS email,
        {{ format_phone_number('raw_json:contact_info:phone::VARCHAR') }} AS phone_number,
        {{ extract_phone_extension('raw_json:contact_info:phone::VARCHAR') }} AS phone_extension,
        raw_json:contact_info:residential_zip_code::VARCHAR AS residential_zip_code,
        raw_json:gender_code::VARCHAR AS gender_code,
        raw_json:social_security_hash::VARCHAR AS social_security_hash,
        raw_json:primary_insurance_id::VARCHAR AS primary_insurance_id,
        raw_json:created_at::TIMESTAMP AS created_at,
        loaded_at
    FROM raw_data
),

count_records AS (
    SELECT COUNT(*) AS record_count
    FROM extracted_json
),
deduplicated AS (
    SELECT * FROM extracted_json
    QUALIFY ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY loaded_at DESC) = 1
),
count_deduplicated AS (
    SELECT COUNT(*) AS record_count
    FROM deduplicated
)

SELECT * FROM deduplicated