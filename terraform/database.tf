resource "random_password" "keycloak_db_password" {
  length  = 20
  special = false
}

resource "google_sql_database_instance" "keycloak_db" {
  name                = "lineage-sample-keycloak-db"
  database_version    = "POSTGRES_16"
  region              = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      enabled = false
    }
  }
}

resource "google_sql_database" "keycloak" {
  name     = "keycloak"
  instance = google_sql_database_instance.keycloak_db.name
}

resource "google_sql_user" "keycloak_user" {
  name     = "keycloak"
  instance = google_sql_database_instance.keycloak_db.name
  password = random_password.keycloak_db_password.result
}

resource "google_project_iam_member" "vm_cloudsql_client" {
  provider = google.bootstrap
  project  = var.project_id
  role     = "roles/cloudsql.client"
  member   = "serviceAccount:${google_service_account.vm_runtime.email}"
}

output "keycloak_db_connection_name" {
  value = google_sql_database_instance.keycloak_db.connection_name
}

output "keycloak_db_password" {
  value     = random_password.keycloak_db_password.result
  sensitive = true
}