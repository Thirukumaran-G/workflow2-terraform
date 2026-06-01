resource "google_secret_manager_secret" "app_secret_key" {
  project   = var.project_id
  secret_id = "${var.environment}-app-secret-key"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "db_url" {
  project   = var.project_id
  secret_id = "${var.environment}-db-url"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "api_key" {
  project   = var.project_id
  secret_id = "${var.environment}-api-key"

  replication {
    auto {}
  }
}