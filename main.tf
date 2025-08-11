terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50.0"
    }
  }
}

# Get the project ID from the user's active gcloud configuration.
data "google_project" "project" {}

# This is the core resource. It creates an IAM binding.
resource "google_project_iam_member" "mysaas_binding_bq" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:customer-accessor@my-saas-project.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "mysaas_binding_storage" {
  project = data.google_project.project.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:customer-accessor@my-saas-project.iam.gserviceaccount.com"
}