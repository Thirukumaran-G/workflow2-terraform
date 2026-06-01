variable "project_id"  { type = string }
variable "region"      { type = string }
variable "app_name"    { type = string }
variable "environment" { type = string }
variable "image"       { type = string }
variable "sa_email"    { type = string }
variable "secrets"     { type = map(string) }