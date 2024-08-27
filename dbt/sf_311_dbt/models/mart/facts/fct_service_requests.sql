select
    request_id,
    service_name,
    created_date,
    closed_date,
    status,
    neighborhood
from {{ ref('stg_sf_311_calls') }}