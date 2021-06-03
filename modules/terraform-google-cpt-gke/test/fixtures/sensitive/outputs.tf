output "project_id" {
  value = module.test_project.project_id
}

output "project_number" {
  value = module.test_project.project_number
}

output "service_account" {
  value = google_service_account.cluster_service_account[0].email
}

output "network_self_link" {
  value = google_compute_network.main.self_link
}

output "network_name" {
  value = google_compute_network.main.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.main.self_link
}

output "subnet_name" {
  value = google_compute_subnetwork.main.name
}

output "subnet_first_range"{
  value = google_compute_subnetwork.main.secondary_ip_range[0].range_name
}

output "subnet_second_range"{
  value = google_compute_subnetwork.main.secondary_ip_range[1].range_name
}

output "subnet_ip_cidr_range"{
  value = google_compute_subnetwork.main.ip_cidr_range
}

output "kmskey_self_link_map" {
  description = "Self link map of the kms keys"
  value = zipmap(
    keys(google_kms_crypto_key.key)[*],
    values(google_kms_crypto_key.key)[*].self_link
  )
}