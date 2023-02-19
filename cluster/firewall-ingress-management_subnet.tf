resource "google_compute_firewall" "ingress_management_subnet" {
  name    = "ingress1management"
  network = google_compute_network.vpc_network.name
  direction     = "INGRESS"
source_ranges = [ "0.0.0.0/0" ]
  allow {
    protocol = "all"
  }

  target_tags = [ "management1subnet1instance"]
}

