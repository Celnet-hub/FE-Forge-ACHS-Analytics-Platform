{{ config(materialized='table') }}

WITH raw_data AS (
    SELECT raw_json, loaded_at FROM {{ source('achs_raw', 'CLAIMS_RAW') }}
),

extracted_json AS (
    SELECT
        raw_json:claim_id::VARCHAR AS claim_id,
        raw_json:encounter_id::VARCHAR AS encounter_id,
        raw_json:payer_id::VARCHAR AS payer_id,
        raw_json:total_billed_amount::NUMBER(38,2) AS total_billed_amount,
        raw_json:amount_paid_by_insurance::NUMBER(38,2) AS amount_paid_by_insurance,
        raw_json:patient_responsibility_amount::NUMBER(38,2) AS patient_responsibility_amount,
        UPPER(TRIM(raw_json:claim_status::VARCHAR)) AS claim_status,
        raw_json:adjudication:denial_reason::VARCHAR AS denial_reason,
        raw_json:adjudication:reimbursement_rate::NUMBER(38,2) AS reimbursement_rate,
        raw_json:adjudication:processed_date::DATE AS processed_date,
        loaded_at
    FROM raw_data
)

SELECT * FROM extracted_json