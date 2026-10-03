{% macro format_phone_number(column_name) %}
    REGEXP_REPLACE(
        RIGHT(
            REGEXP_REPLACE(
                SPLIT_PART(LOWER({{ column_name }}), 'x', 1), 
                '[^0-9]', ''
            ), 10
        ), 
        '([0-9]{3})([0-9]{3})([0-9]{4})', 
        '(\\1)-\\2-\\3'
    )
{% endmacro %}