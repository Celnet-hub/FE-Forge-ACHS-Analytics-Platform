{{ config(
    materialized='table',
    schema='gold',
    cluster_by=['residential_zip_code'] 
) }}

WITH silver_patients AS (
    SELECT * FROM {{ ref('silver_patients') }}
),

dim_patients AS (
    SELECT
        patient_id,
        first_name,
        last_name,
        social_security_hash,
        date_of_birth,
        gender_code,
        residential_zip_code,
        primary_insurance_id
    FROM silver_patients
)

-- select tables
SELECT * FROM dim_patients