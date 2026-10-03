{% macro convert_to_boolean(column_name) %}
    CASE
        WHEN UPPER(TRIM({{ column_name }})) IN ('TRUE', '1', 'Y') THEN TRUE
        -- WHEN UPPER(TRIM({{ column_name }})) IN ('FALSE', '0', 'N') THEN FALSE
        ELSE FALSE
    END
{% endmacro %}