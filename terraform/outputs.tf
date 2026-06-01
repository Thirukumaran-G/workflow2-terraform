output "cloud_run_url" {
  value = module.cloud_run.service_url
}

output "artifact_registry_url" {
  value = module.artifact_registry.registry_url
}

output "workload_identity_provider" {
  description = "Copy this value into GitHub Secret WIF_PROVIDER"
  value       = module.workload_identity.provider_name
}

output "github_actions_sa_email" {
  description = "Copy this value into GitHub Secret GCP_SA_EMAIL"
  value       = module.iam.github_actions_sa_email
}