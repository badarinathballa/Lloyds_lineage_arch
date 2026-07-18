resource "google_service_account" "vm_runtime" {
  provider     = google.bootstrap
  account_id   = "lineage-sample-vm"
  display_name = "Lineage Sample - VM Runtime Identity"
}

resource "google_project_iam_member" "vm_logging" {
  provider = google.bootstrap
  project  = var.project_id
  role     = "roles/logging.logWriter"
  member   = "serviceAccount:${google_service_account.vm_runtime.email}"
}

resource "google_compute_instance" "kong_sample_vm" {
  name         = "lineage-sample-vm"
  machine_type = "e2-medium"
  zone         = "${var.region}-a"
  tags         = ["ssh-allowed", "kong-sample"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
    access_config {}
  }

  service_account {
    email  = google_service_account.vm_runtime.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y podman
    echo "Podman installed: $(podman --version)" > /var/log/startup-script-done.log
  EOF
}

output "vm_external_ip" {
  value = google_compute_instance.kong_sample_vm.network_interface[0].access_config[0].nat_ip
}

output "vm_name" {
  value = google_compute_instance.kong_sample_vm.name
}