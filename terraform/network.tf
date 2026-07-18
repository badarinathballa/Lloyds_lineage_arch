resource "google_compute_network" "lineage_sample_vpc" {
  name                    = "lineage-sample-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "lineage-sample-public-subnet"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.lineage_sample_vpc.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "lineage-sample-allow-ssh"
  network = google_compute_network.lineage_sample_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-allowed"]
}

resource "google_compute_firewall" "allow_kong_test_ports" {
  name    = "lineage-sample-allow-kong-ports"
  network = google_compute_network.lineage_sample_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["8000", "8001", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kong-sample"]
}

output "vpc_id" {
  value = google_compute_network.lineage_sample_vpc.id
}

output "public_subnet_id" {
  value = google_compute_subnetwork.public_subnet.id
}