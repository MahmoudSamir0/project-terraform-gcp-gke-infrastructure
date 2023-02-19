resource "google_compute_firewall" "final-egress" {
  name    = "managementegress"
  network = google_compute_network.vpc_network.name
    direction     = "EGRESS"
destination_ranges = [ "0.0.0.0/0" ]
allow {
      protocol = "all"
}
  target_tags = [ "management1subnet1instance"]
}

resource "google_compute_firewall" "final-egress-deny" {
  name    = "restricted1egress"
  network = google_compute_network.vpc_network.name
    direction     = "EGRESS"
destination_ranges = [ "0.0.0.0/0" ]
deny {
      protocol = "all"
      
}
  target_tags = [ "restricted1subnet1gke"]
}