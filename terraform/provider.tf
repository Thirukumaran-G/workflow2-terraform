terraform {
  required_version = ">= 1.9.0"    # upgrade terraform version

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"            # use 6.x — has valid signature
    }
  }

  backend "gcs" {}
}

provider "google" {
  project = var.project_id
  region  = var.region
}