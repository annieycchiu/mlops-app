{{ config(materialized='table') }}

select
    neighborhood,
    count(request_id) as total_requests,
    avg({{ calculate_response_time('closed_date', 'created_date') }}) as avg_response_time
from {{ ref('stg_sf_311_calls') }}
where status = 'Closed'
group by neighborhood