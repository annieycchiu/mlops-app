WITH raw_data AS (
    SELECT
        service_request_id AS request_id,
        service_name,
        DATE(TIMESTAMP(requested_datetime)) AS created_date,
        DATE(TIMESTAMP(closed_date)) AS closed_date,
        status_description AS status,
        neighborhoods_sffind_boundaries AS neighborhood
    FROM {{ source('sf_311', '311_data') }}
),

ranked_data AS (
    SELECT
        request_id,
        service_name,
        created_date,
        closed_date,
        status,
        neighborhood,
        ROW_NUMBER() OVER (PARTITION BY request_id ORDER BY closed_date DESC) AS row_num
    FROM raw_data
)

SELECT
    request_id,
    service_name,
    created_date,
    closed_date,
    status,
    neighborhood
FROM ranked_data
WHERE row_num = 1
