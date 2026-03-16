terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "cipher_api" {
  location      = var.region
  repository_id = "cipher-api-repo"
  format        = "DOCKER"
  description   = "AskCipher API Docker images"
}

resource "google_sql_database_instance" "cipher_db" {
  name             = "cipher-db"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier    = "db-f1-micro"
    edition = "ENTERPRISE"
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "cipher_db" {
  name     = "cipher_db"
  instance = google_sql_database_instance.cipher_db.name
}

resource "google_sql_user" "cipher_user" {
  name     = "cipher_user"
  instance = google_sql_database_instance.cipher_db.name
  password = var.db_password
}

resource "google_service_account" "github_actions" {
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}

resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
