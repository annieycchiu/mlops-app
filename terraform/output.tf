output "db_instance_public_ip" {
  value = google_sql_database_instance.instance.ip_address[0].ip_address
}

output "wif_pool_name" {
  description = "Pool name"
  value       = google_iam_workload_identity_pool.pool.name
}
output "wif_provider_name" {
  description = "Provider name"
  value       = google_iam_workload_identity_pool_provider.pool_provider.name
}

output "service_account_email" {
  value = google_service_account.sa.email
}