resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  count        = 1
  project      = module.test_project.project_id
  account_id   = "tf-gke-${random_string.cluster_service_account_suffix.result}"
  display_name = "Terraform-managed service account for cluster GKE test"
}

resource "google_project_iam_member" "cluster_service_account-log_writer" {
  count   = 1
  project = google_service_account.cluster_service_account[0].project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-metric_writer" {
  count   = 1
  project = google_project_iam_member.cluster_service_account-log_writer[0].project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-monitoring_viewer" {
  count   = 1
  project = google_project_iam_member.cluster_service_account-metric_writer[0].project
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-resourceMetadata-writer" {
  count   = 1
  project = google_project_iam_member.cluster_service_account-monitoring_viewer[0].project
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-gcr" {
  count   = 1
  project = module.test_project.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-os-login" {
  count   = 1
  project = module.test_project.project_id
  role    = "roles/compute.osLogin"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}
