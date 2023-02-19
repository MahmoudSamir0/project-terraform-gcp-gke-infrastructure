resource "google_compute_firewall" "ingress-restricted_subnet" {
  name    = "ingress1restricted"
  network = google_compute_network.vpc_network.name
  direction     = "INGRESS"
source_ranges = [ "10.0.8.0/24" ]
allow {
      protocol = "all"
}
}
