{{ config(materialized='table') }}

WITH raw_data AS (
    SELECT raw_json, loaded_at FROM {{ source('achs_raw', 'DIAGNOSES_RAW') }}
),

extracted_json AS (
    SELECT
        raw_json:diagnosis_id::VARCHAR AS diagnosis_id,
        raw_json:encounter_id::VARCHAR AS encounter_id,
        raw_json:icd_10_code::VARCHAR AS icd_10_code,
        raw_json:diagnosis_rank::VARCHAR AS diagnosis_rank,
        raw_json:coding_system::VARCHAR AS coding_system,
        raw_json:recorded_at_timestamp::TIMESTAMP_LTZ AS recorded_at_timestamp,
        loaded_at
    FROM raw_data
)

SELECT * FROM extracted_json