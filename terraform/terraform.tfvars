project_id = "my-eighth-project-431723"
region = "us-west1"

service_account_id = "mlops-sa"

# CI/CD
github_repo = "annieycchiu/mlops-eighth"

# Database
db_instance_name = "mlflow-instance"
db_name = "mlflow-db"
db_user = "user1"

# Set sensitive data such as "db_password" using environment variables
# export TF_VAR_db_password="xxxxx"

# Artifact registries
mlflow_ar_name = "mlflow-server"
model_ar_name = "fastapi-app"

# Buckets
mlflow_bucket_name = "my-mlflow-artifacts-bucket"
model_bucket_name = "my-best-gaming-model"