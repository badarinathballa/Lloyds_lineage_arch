resource "google_service_account" "terraform" {
  provider     = google.bootstrap
  account_id   = "terraform-lineage-sample"
  display_name = "Terraform - Lineage Sample Project"
}

resource "google_project_iam_member" "terraform_compute_admin" {
  provider = google.bootstrap
  project  = var.project_id
  role     = "roles/compute.admin"
  member   = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_member" "terraform_cloudsql_admin" {
  provider = google.bootstrap
  project  = var.project_id
  role     = "roles/cloudsql.admin"
  member   = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_member" "terraform_sa_user" {
  provider = google.bootstrap
  project  = var.project_id
  role     = "roles/iam.serviceAccountUser"
  member   = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_member" "terraform_storage_admin" {
  provider = google.bootstrap
  project  = var.project_id
  role     = "roles/storage.admin"
  member   = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_service_account_key" "terraform_key" {
  provider            = google.bootstrap
  service_account_id  = google_service_account.terraform.name
}

output "terraform_sa_email" {
  value = google_service_account.terraform.email
}

output "terraform_sa_key_b64" {
  value     = google_service_account_key.terraform_key.private_key
  sensitive = true
}