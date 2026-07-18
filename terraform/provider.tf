terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

# Default provider - used for actual infrastructure: VPC, VM, Cloud SQL, etc.
# Authenticates as the terraform-lineage-sample service account.
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

# Bootstrap provider - used only for identity/IAM resources (iam.tf).
# Managing IAM policy requires Owner-level rights, which the service account
# intentionally does NOT have on itself - a service account being able to
# grant itself more power would be a security hole, not a convenience.
# This falls back to your personal gcloud login (Application Default
# Credentials), which has Owner rights on this project.
provider "google" {
  alias   = "bootstrap"
  project = var.project_id
  region  = var.region
}