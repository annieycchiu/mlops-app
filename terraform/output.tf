output "db_instance_public_ip" {
  value = google_sql_database_instance.instance.ip_address[0].ip_address
}