provider "google" {
  project = var.project_id
  region  = "us-west1"
}

provider "google-beta" {
  project = var.project_id
  region  = "us-west1"
}

resource "google_sql_database_instance" "instance" {
  name                = "mlflow-instance-tf"
  database_version    = "POSTGRES_15"
  region              = "us-west1"
  deletion_protection = false

  settings {
    tier      = "db-f1-micro"
    disk_type = "PD_HDD"
    disk_size = 10

    ip_configuration {
      authorized_networks {
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_user" "user" {
  name     = "user-tf"
  instance = google_sql_database_instance.instance.name
  password = var.db_password
}

resource "google_sql_database" "database" {
  name     = "mlflow-db-tf"
  instance = google_sql_database_instance.instance.name
}

resource "google_storage_bucket" "mlflow_bucket" {
  name     = "the-mlflow-bucket-tf"
  location = "US"
}

resource "google_artifact_registry_repository" "mlflow_repo" {
  provider      = "google-beta"
  location      = "us-west1"
  repository_id = "mlflow-server-tf"
  format        = "DOCKER"
}

resource "google_service_account" "sa" {
  account_id = "my-sa-tf"
}

# IAM bindings
resource "google_project_iam_binding" "cloudsql_editor" {
  project = var.project_id
  role    = "roles/cloudsql.editor"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "artifactregistry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "cloudfunctions_admin" {
  project = var.project_id
  role    = "roles/cloudfunctions.admin"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "clouddeploy_service_agent" {
  project = var.project_id
  role    = "roles/clouddeploy.serviceAgent"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

# Secret Manager for database URL
resource "google_secret_manager_secret" "database_url" {
  secret_id = "database_url_tf"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "database_url_version" {
  secret      = google_secret_manager_secret.database_url.id
  secret_data = "postgresql://user-tf:${var.db_password}@${google_sql_database_instance.instance.public_ip_address}/mlflow-db-tf"
}

# Secret Manager for bucket URL
resource "google_secret_manager_secret" "bucket_url" {
  secret_id = "bucket_url_tf"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "bucket_url_version" {
  secret      = google_secret_manager_secret.bucket_url.id
  secret_data = "gs://the-mlflow-bucket-tf/mlruns"
}
