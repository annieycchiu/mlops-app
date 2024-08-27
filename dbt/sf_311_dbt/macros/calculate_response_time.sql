{% macro calculate_response_time(closed_date, created_date) %}
    {{ closed_date }} - {{ created_date }}
{% endmacro %}