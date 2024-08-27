from datetime import datetime, timedelta

from prefect import task, flow
from prefect.blocks.system import Secret
from prefect.deployments import DeploymentImage

from google.cloud import bigquery, storage
from sodapy import Socrata

# insert record into Bigquery
def insert_record_one_by_one(client, table_id, records, print_successful_records=True):
    failed_records = []
    
    for record in records:
        errors = client.insert_rows_json(table_id, [record])
        
        if errors:
            failed_records.append({'record': record, 'errors': errors})
        else:
            if print_successful_records:
                print(f"Record inserted successfully: {record}")
    
    return failed_records

@task
async def fetch_secret(name):
    # Load the secret asynchronously
    secret_block = await Secret.load(name)
    return secret_block.get()

@task(cache_expiration=timedelta(hours=1))
def fetch_data(client, data_limit=100):
    data = client.get(
        dataset_identifier='vw6y-z8j6', 
        limit=data_limit
    )
    return data

@task
def transform_data(data):
    needed_keys = [
        'service_request_id', 'requested_datetime', 'closed_date', 'updated_datetime', 'status_description', 
        'status_notes', 'agency_responsible', 'service_name', 'service_subtype', 'service_details', 'address', 
        'street', 'supervisor_district', 'neighborhoods_sffind_boundaries', 'police_district', 'lat', 'long', 'source'
    ]
    filtered_data = []
    for d in data:
        # retrive needed data
        filtered_dict = {} 
        for k, v in d.items():
            if k in needed_keys: 
                # convert datatype of values to string
                if v is not None and not isinstance(v, str):
                    v = str(v)
                filtered_dict[k] = v 
        filtered_data.append(filtered_dict) 
    return filtered_data

@task
def load_data_to_bigquery(bq_client, bq_table_id, gcs_client, bucket_name, data):
    failed_records = insert_record_one_by_one(bq_client, bq_table_id, data)
    
    if failed_records:
        report_name = f"failed_records_report_{datetime.today().strftime('%Y-%m-%d')}.txt"
        report_content = ""
        
        for entry in failed_records:
            report_content += f"Record: {entry['record']}\n"
            report_content += f"Errors: {entry['errors']}\n"
            report_content += "\n---\n\n"

        bucket = gcs_client.bucket(bucket_name)
        blob = bucket.blob(report_name)
        blob.upload_from_string(report_content)
        
        print(f"Report of failed records has been uploaded to GCP bucket '{bucket_name}' as '{report_name}'.")

    else:
        print("All records were inserted successfully.")


# Define the Prefect flow
@flow(name='311 data ETL', log_prints=True)
async def etl_flow(data_limit=10):
    # Load the secret
    socrata_app_token = await fetch_secret('socrata-app-token')
    socrata_username = await fetch_secret('socrata-username')
    socrata_password = await fetch_secret('socrata-password')
    
    # Initialize clients
    socrata_client = Socrata(
        'data.sfgov.org', 
        app_token=socrata_app_token,
        username=socrata_username,
        password=socrata_password
        )
    bigquery_client = bigquery.Client()
    storage_client = storage.Client()
    bigquery_table_id = 'my-tenth-project-432516.test_dataset.311_data'
    bucket_name = 'my-prefect-bucket'
    
    # Run tasks
    data = fetch_data(socrata_client, data_limit)
    transformed_data = transform_data(data)
    load_data_to_bigquery(
        bigquery_client, bigquery_table_id, 
        storage_client, bucket_name, 
        transformed_data
        )

    print('Complete the task!')

# Run the flow
if __name__ == "__main__":
    etl_flow.deploy(                                                            
        name='311-data-etl-deployment',
        work_pool_name='my-cloud-run-pool',
        cron='0 1 * * *',
        image=DeploymentImage(
            name='prefect-etl-image:latest',
            platform='linux/amd64',
        )
    )

