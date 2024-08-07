variable "db_password" {
  description = "The password for the database user."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The region for all resources."
  type        = string
  default     = "us-west1"
}

variable "service_account_id" {
  description = "The service account ID to be used for resource management."
  type        = string
}

variable "github_repo" {
  description = "The name of GitHub repository for CI/CD."
  type        = string
}

variable "db_instance_name" {
  description = "The name of the database instance for MLflow."
  type        = string
}

variable "db_name" {
  description = "The name of the database for MLflow."
  type        = string
}

variable "db_user" {
  description = "The username for accessing the MLflow database."
  type        = string
}

variable "mlflow_ar_name" {
  description = "The name of the Artifact Registry repository for MLflow artifacts."
  type        = string
}

variable "model_ar_name" {
  description = "The name of the Artifact Registry repository for model artifacts."
  type        = string
}

variable "mlflow_bucket_name" {
  description = "The name of the Google Cloud Storage bucket for MLflow artifacts."
  type        = string
}

variable "model_bucket_name" {
  description = "The name of the Google Cloud Storage bucket for model artifacts."
  type        = string
}
