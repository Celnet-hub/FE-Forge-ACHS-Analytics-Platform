{{ config(
    materialized='table',
    schema='gold',
    cluster_by=['recorded_date', 'icd_10_code']
) }}

WITH silver_diagnoses AS (
    SELECT * FROM {{ ref('silver_diagnoses') }}
),

silver_encounters AS (
    SELECT 
        encounter_id,
        patient_id
    FROM {{ ref('silver_encounters') }}
),

fact_diagnoses AS (
    SELECT
        d.diagnosis_id,
        d.encounter_id,
        e.patient_id,
        d.icd_10_code,
        d.diagnosis_rank,
        d.coding_system,
        d.recorded_at_timestamp,
        TO_VARCHAR(d.recorded_at_timestamp, 'YYYYMMDD')::NUMBER AS recorded_date
    FROM silver_diagnoses d
    LEFT JOIN silver_encounters e
    ON d.encounter_id = e.encounter_id
)

SELECT * FROM fact_diagnoses