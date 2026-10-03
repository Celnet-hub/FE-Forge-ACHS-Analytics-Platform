{{ config(
    materialized='table',
    schema='gold',
    cluster_by=['encounter_start_date', 'provider_id']
) }}

WITH silver_encounters AS (
    SELECT * FROM {{ ref('silver_encounters') }}
),

fact_encounters AS (
    SELECT
        encounter_id,
        patient_id,
        provider_id,
        admission_source,
        encounter_class,
        encounter_start_timestamp,
        encounter_end_timestamp,
        
        -- Generating Date Keys for dim_date joins (Format: YYYYMMDD)
        TO_VARCHAR(encounter_start_timestamp, 'YYYYMMDD')::NUMBER AS encounter_start_date,
        TO_VARCHAR(encounter_end_timestamp, 'YYYYMMDD')::NUMBER AS encounter_end_date,
        
        DATEDIFF('minute', encounter_start_timestamp, encounter_end_timestamp) AS visit_duration
        
    FROM silver_encounters
)

SELECT * FROM fact_encounters