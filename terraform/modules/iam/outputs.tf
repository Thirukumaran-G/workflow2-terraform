output "github_actions_sa_email" {
  value = google_service_account.github_actions.email
}

output "cloud_run_sa_email" {
  value = google_service_account.cloud_run.email
}