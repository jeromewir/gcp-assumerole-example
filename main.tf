terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50.0"
    }
  }
}

# Define an input variable to receive the project ID from our script.
variable "project_id" {
  type        = string
  description = "The GCP project ID to apply permissions to."
}

# This is the core resource. It creates an IAM binding.
# Notice it now uses var.project_id instead of the old data source.
resource "google_project_iam_member" "mysaas_binding_bq" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:customer-accessor@my-saas-project.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "mysaas_binding_storage" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:customer-accessor@my-saas-project.iam.gserviceaccount.com"
}