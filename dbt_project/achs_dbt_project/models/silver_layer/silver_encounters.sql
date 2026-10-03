{{ config(materialized='table') }}

WITH raw_data AS (
    SELECT raw_json, loaded_at FROM {{ source('achs_raw', 'ENCOUNTERS_RAW') }}
),

extracted_json AS (
    SELECT
        raw_json:encounter_id::VARCHAR AS encounter_id,
        raw_json:patient_id::VARCHAR AS patient_id,
        raw_json:provider_id::VARCHAR AS provider_id,
        raw_json:encounter_start_timestamp::TIMESTAMP_LTZ AS encounter_start_timestamp,
        raw_json:encounter_end_timestamp::TIMESTAMP_LTZ AS encounter_end_timestamp,
        raw_json:admission_source::VARCHAR AS admission_source,
        raw_json:encounter_class::VARCHAR AS encounter_class,
        loaded_at
    FROM raw_data
)

SELECT * FROM extracted_json