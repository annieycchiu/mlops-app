select *
from {{ ref('stg_sf_311_calls') }}
where status = 'Closed' and closed_date is null