terraform {
  backend "gcs" {
    bucket = "gcp-learning-490101-tfstate"
    prefix = "lineage-sample/state"
  }
}
