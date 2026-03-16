variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "askcipher-devops-490323"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "db_password" {
  description = "PostgreSQL user password"
  type        = string
  sensitive   = true
}
