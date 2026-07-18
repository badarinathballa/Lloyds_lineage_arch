variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Primary GCP region"
  type        = string
  default     = "northamerica-northeast1"
}

variable "credentials_file" {
  description = "Path to the Terraform service account JSON key"
  type        = string
}
