resource "google_project_iam_binding" "tunnel_resource_accessor" {
  project       = module.test_project.project_id
  role          = "roles/iap.tunnelResourceAccessor"

  members       = var.bastion_members
}

resource "google_project_iam_binding" "compute_admin" {
 project       = module.test_project.project_id
 role          = "roles/compute.admin"

  members       = var.bastion_members
}

resource "google_project_iam_binding" "iam_seriveAccountUser" {
 project       = module.test_project.project_id
 role          = "roles/iam.serviceAccountUser"

  members       = var.bastion_members
}
