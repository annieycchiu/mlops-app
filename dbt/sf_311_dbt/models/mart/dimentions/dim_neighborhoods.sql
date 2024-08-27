select
    distinct neighborhood as neighborhood_name,
    md5(neighborhood) as neighborhood_id
from {{ ref('stg_sf_311_calls') }}