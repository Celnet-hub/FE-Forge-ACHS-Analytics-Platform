{{ config(
    materialized='table',
    schema='gold',
    cluster_by=['encounter_start_date', 'provider_id']
) }}