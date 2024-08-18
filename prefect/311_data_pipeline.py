import os
from prefect import task, flow
from sodapy import Socrata
from google.cloud import bigquery
from google.oauth2 import service_account
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Define the fetch_data task
@task
def fetch_data(client, data_limit=100):
    data = client.get(
        dataset_identifier='vw6y-z8j6', 
        limit=data_limit
    )
    return data

# Define the transform_data task
@task
def transform_data(data):
    needed_keys = [
        'service_request_id', 'requested_datetime', 'closed_date', 'updated_datetime', 'status_description', 'status_notes',
        'agency_responsible', 'service_name', 'service_subtype', 'service_details', 'address', 'street', 'supervisor_district',
        'neighborhoods_sffind_boundaries', 'police_district', 'lat', 'long', 'source'
    ]
    filtered_data = []
    for d in data:
        filtered_dict = {} 
        for k, v in d.items():
            if k in needed_keys: 
                if v is not None and not isinstance(v, str):
                    v = str(v)
                filtered_dict[k] = v 
        filtered_data.append(filtered_dict) 
    return filtered_data

# Define the insert_record_one_by_one task
@task
def insert_record_one_by_one(client, table_id, records):
    failed_records = []
    
    for record in records:
        errors = client.insert_rows_json(table_id, [record])
        
        if errors:
            failed_records.append({'record': record, 'errors': errors})
        else:
            print(f"Record inserted successfully: {record}")
    
    return failed_records

# Define the load_data_to_bigquery task
@task
def load_data_to_bigquery(client, data):
    table_id = 'my-tenth-project-432516.test_dataset.311_data'
    failed_records = insert_record_one_by_one(client, table_id, data)
    
    if failed_records:
        with open('failed_records_report.txt', 'w') as f:
            for entry in failed_records:
                f.write(f"Record: {entry['record']}\n")
                f.write(f"Errors: {entry['errors']}\n")
                f.write("\n---\n\n")
        print("Report of failed records has been written to 'failed_records_report.txt'.")
    else:
        print("All records were inserted successfully.")

# Set up Socrata client
@task
def setup_socrata_client():
    return Socrata(
        'data.sfgov.org',
        app_token=os.getenv('SOCRATA_APP_TOKEN'),
        username=os.getenv('SOCRATA_USERNAME'),
        password=os.getenv('SOCRATA_PASSWORD')
    )

# Set up BigQuery client
@task
def setup_bigquery_client():
    key_path = os.getenv('GCP_ACCESS_KEY') 
    credentials = service_account.Credentials.from_service_account_file(key_path)
    return bigquery.Client(
        credentials=credentials, 
        project=credentials.project_id
    )

# Define the Prefect flow
@flow
def etl_flow(data_limit=10):
    socrata_client = setup_socrata_client()
    bigquery_client = setup_bigquery_client()
    
    data = fetch_data(socrata_client, data_limit)
    transformed_data = transform_data(data)
    load_data_to_bigquery(bigquery_client, transformed_data)

# Run the flow
if __name__ == "__main__":
    etl_flow()

