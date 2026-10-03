{% macro extract_phone_extension(column_name) %}
    NULLIF(
        REGEXP_REPLACE(
            SPLIT_PART(LOWER({{ column_name }}), 'x', 2), 
            '[^0-9]', ''
        ), ''
    )
{% endmacro %}