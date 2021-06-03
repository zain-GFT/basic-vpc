resource "google_project_service" "gcp_container_analysis" {
  project = var.project_id
  service = "containeranalysis.googleapis.com"
}

resource "google_project_service" "gcp_container_scanning" {
  project = var.project_id
  service = "containerscanning.googleapis.com"
  depends_on = [
    google_project_service.gcp_container_analysis
  ]
}