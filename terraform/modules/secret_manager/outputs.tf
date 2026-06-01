output "secret_ids" {
  value = {
    app_secret_key = google_secret_manager_secret.app_secret_key.secret_id
    db_url         = google_secret_manager_secret.db_url.secret_id
    api_key        = google_secret_manager_secret.api_key.secret_id
  }
}