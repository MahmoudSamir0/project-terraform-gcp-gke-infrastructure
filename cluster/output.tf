output "vpc-id" {
  value = google_compute_network.vpc_network.id
}
output "vpc-name" {
  value = google_compute_network.vpc_network.name
}
output "management-subnet-id" {
  value = google_compute_subnetwork.management_subnet.id
}
output "management-subnet-name" {
  value = google_compute_subnetwork.management_subnet.name
}
output "restricted_subnet_name" {
  value = google_compute_subnetwork.restricted_subnet.name
}
output "restricted_subnet_id" {
    value = google_compute_subnetwork.restricted_subnet.id

}
