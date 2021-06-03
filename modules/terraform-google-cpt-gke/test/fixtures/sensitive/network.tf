resource "google_compute_network" "main" {
  project                 = module.test_project.project_id
  name                    = "private-gke-test-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  project       = module.test_project.project_id
  name          = "private-gke-test-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/17"
  region        = var.region
  network       = google_compute_network.main.self_link

  secondary_ip_range {
    range_name    = "private-gke-test-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "private-gke-test-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.64.0/18"
  }
}

resource "google_compute_firewall" "allow_from_iap_to_instances" {
  project = module.test_project.project_id
  name    = "allow-ssh-from-iap-to-tunnel"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"
    ports    = toset(concat(["22"]))
  }

  # https://cloud.google.com/iap/docs/using-tcp-forwarding#before_you_begin
  # This is the netblock needed to forward to the instances
  source_ranges = ["35.235.240.0/20"]

  target_service_accounts = null
  target_tags             =  null
}