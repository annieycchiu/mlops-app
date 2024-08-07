provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Enable APIs
resource "google_project_service" "iam_credentials_api" {
  project = var.project_id
  service = "iamcredentials.googleapis.com"
}

resource "google_project_service" "artifact_registry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "secret_manager_api" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
}

resource "google_project_service" "run_api" {
  project = var.project_id
  service = "run.googleapis.com"
}

# Workload Identity Pool for Github Actions
resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = "github-pool"
}

resource "google_iam_workload_identity_pool_provider" "pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  attribute_condition                = "attribute.repository=='${var.github_repo}'"
  attribute_mapping                  = {
    "google.subject" = "assertion.sub"
    "attribute.actor" = "assertion.actor"
    "attribute.aud" = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "sa" {
  project    = var.project_id
  account_id = var.service_account_id
}

resource "google_service_account_iam_member" "iam_workload_identity_user" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/*"
}

resource "google_project_iam_binding" "cloudsql_editor_iam_binding" {
  project = var.project_id
  role    = "roles/cloudsql.editor"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "storage_object_admin_iam_binding" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "secretmanager_secret_accessor_iam_binding" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "artifactregistry_admin_iam_binding" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "cloudfunctions_admin_iam_binding" {
  project = var.project_id
  role    = "roles/cloudfunctions.admin"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

resource "google_project_iam_binding" "clouddeploy_service_agent_iam_binding" {
  project = var.project_id
  role    = "roles/clouddeploy.serviceAgent"

  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}

# MLflow server
resource "google_sql_database_instance" "instance" {
  project             = var.project_id
  name                = var.db_instance_name
  database_version    = "POSTGRES_15"
  region              = var.region
  deletion_protection = false  # default is set to true to prevent data loss

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
  project  = var.project_id
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = var.db_password
}

resource "google_sql_database" "database" {
  project  = var.project_id
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}

resource "google_artifact_registry_repository" "mlflow_repo" {
  project       = var.project_id
  provider      = google-beta
  location      = var.region
  repository_id = var.mlflow_ar_name
  format        = "DOCKER"
}

resource "google_storage_bucket" "mlflow_bucket" {
  project  = var.project_id
  name     = var.mlflow_bucket_name
  location = "US"
}

# Secret Manager for database URL
resource "google_secret_manager_secret" "database_url" {
  project   = var.project_id
  secret_id = "database_url"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "database_url_version" {
  secret      = google_secret_manager_secret.database_url.id
  secret_data = "postgresql://${var.db_user}:${var.db_password}@${google_sql_database_instance.instance.public_ip_address}/${var.db_name}"
}

# Secret Manager for bucket URL
resource "google_secret_manager_secret" "bucket_url" {
  project   = var.project_id
  secret_id = "bucket_url"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "bucket_url_version" {
  secret      = google_secret_manager_secret.bucket_url.id
  secret_data = "gs://${var.mlflow_bucket_name}/mlruns"
}


resource "google_artifact_registry_repository" "fastapi_repo" {
  project       = var.project_id
  provider      = google-beta
  location      = var.region
  repository_id = var.model_ar_name
  format        = "DOCKER"
}

resource "google_storage_bucket" "fastapi_bucket" {
  project  = var.project_id
  name     = var.model_bucket_name
  location = "US"
}