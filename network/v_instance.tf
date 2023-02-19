resource "google_service_account" "default" {
  account_id   = "virtualservice"
  display_name = "Service Account"
}

resource "google_project_iam_member" "compute_service" {
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
  project = google_service_account.default.project
}

resource "google_compute_instance" "private_vm" {
  name         = "privatevm"
  machine_type = "f1-micro"
  zone         = "us-west1-b"
  tags = [ "management1subnet1instance" ]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
 
  network_interface {
    network = "final-task-vpc"
    subnetwork = "managementsubnet"

  }
  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}