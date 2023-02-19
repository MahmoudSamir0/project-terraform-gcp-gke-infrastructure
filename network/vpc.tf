resource "google_compute_network" "vpc_network" {
  name = "final-task-vpc"
  auto_create_subnetworks = false

}
resource "google_compute_subnetwork" "management_subnet" {
  name          = "managementsubnet"
  ip_cidr_range = "10.0.8.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "restricted_subnet" {
  name          = "restricted1subnet"
  ip_cidr_range = "10.0.7.0/24"
  region        = "us-west2"  
  private_ip_google_access = true
  network       = google_compute_network.vpc_network.id
  secondary_ip_range  {
    ip_cidr_range = "10.0.16.0/21"
    range_name    = "k8s-pod-range"
      }
  secondary_ip_range  {
    ip_cidr_range = "10.0.48.0/21"
    range_name    = "k8s-service-range"
      }
}
resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.management_subnet.region
  network = google_compute_network.vpc_network.id
}


resource "google_compute_router_nat" "nat" {
  name   = "mynat"
  router                             = google_compute_router.router.name
  region                             = "us-west1"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"


}

