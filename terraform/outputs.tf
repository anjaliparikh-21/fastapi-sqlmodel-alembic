output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/cipher-api-repo"
}

output "cloud_sql_connection" {
  value = google_sql_database_instance.cipher_db.connection_name
}

output "service_account_email" {
  value = google_service_account.github_actions.email
}
