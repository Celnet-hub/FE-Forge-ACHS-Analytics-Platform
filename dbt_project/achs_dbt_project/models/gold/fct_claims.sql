{{ config(
    materialized='table',
    schema='gold',
    cluster_by=['processed_date', 'payer_id'] 
) }}

WITH silver_claims AS (
    SELECT * FROM {{ ref('silver_claims') }}
),

silver_encounters AS (
    SELECT 
        encounter_id,
        patient_id,
        provider_id
    FROM {{ ref('silver_encounters') }}
),

fact_claims AS (
    SELECT
        c.claim_id,
        c.encounter_id,
        c.payer_id,
        e.patient_id,
        e.provider_id,
        
        c.total_billed_amount,
        c.amount_paid_by_insurance,
        c.patient_responsibility_amount,
        c.claim_status,
        c.denial_reason,
        c.reimbursement_rate,
        c.processed_date,
        TO_VARCHAR(c.processed_date, 'YYYYMMDD')::NUMBER AS numeric_processed_date
        
    FROM silver_claims c
    LEFT JOIN silver_encounters e 
        ON c.encounter_id = e.encounter_id
)

SELECT * FROM fact_claims