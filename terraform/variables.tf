variable "db_password" {
  description = "The password for the database user."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}