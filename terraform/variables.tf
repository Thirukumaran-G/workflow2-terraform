variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "fastapi-app"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "github_repo" {
  type = string
}