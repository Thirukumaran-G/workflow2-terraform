locals {
  image_url = "${var.region}-docker.pkg.dev/${var.project_id}/${var.app_name}/${var.app_name}:${var.image_tag}"
}

module "artifact_registry" {
  source     = "./modules/artifact_registry"
  project_id = var.project_id
  region     = var.region
  app_name   = var.app_name
}

module "secret_manager" {
  source      = "./modules/secret_manager"
  project_id  = var.project_id
  environment = var.environment
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  app_name   = var.app_name
}

module "workload_identity" {
  source      = "./modules/workload_identity"
  project_id  = var.project_id
  github_repo = var.github_repo
  sa_email    = module.iam.github_actions_sa_email
}

module "cloud_run" {
  source      = "./modules/cloud_run"
  project_id  = var.project_id
  region      = var.region
  app_name    = var.app_name
  environment = var.environment
  image       = local.image_url
  sa_email    = module.iam.cloud_run_sa_email
  secrets     = module.secret_manager.secret_ids
}