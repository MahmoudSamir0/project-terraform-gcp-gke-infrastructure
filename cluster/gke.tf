resource "google_service_account" "myservice-account-gke" {
  account_id   = "service"
  display_name = "myservice-account-gke"

}

resource "google_project_iam_member" "role_gke" {
   role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.myservice-account-gke.email}"
  project = google_service_account.myservice-account-gke.project
  
}
resource "google_container_cluster" "my-cluster" {
  name     = "my-gke-cluster"
  location = "us-west2-a"
  network       = google_compute_network.vpc_network.id
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  subnetwork = google_compute_subnetwork.restricted_subnet.id
master_authorized_networks_config {
  cidr_blocks {
    display_name = "my_cidr"
    cidr_block = "10.0.8.0/24"
  }
}
  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }
  network_policy {
    enabled = true
  }
    private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.0.11.0/28"
    master_global_access_config {
      enabled = true
    }
  }   
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-task-node-pool"
  location   = "us-west2-a"
  cluster    = google_container_cluster.my-cluster.name
  node_count = 1
  node_config {
    preemptible = true
    machine_type = "e2-medium"

    service_account = google_service_account.myservice-account-gke.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}

