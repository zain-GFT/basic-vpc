##
## Important: the following resources are implemented as a temporary measure until VPC connectivity to on-premises is achieved.
##

locals {
  bastion_name = format("%s-bastion", var.name)
  bastion_zone = format("%s-a", var.region)
}

data "template_file" "startup_script" {
  count    = var.enable_bastion ? 1 : 0
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 6.0"

  name_prefix        = "bastion-instance-template"
  project_id         = var.project_id
  machine_type       = "g1-small"
  disk_size_gb       = 100
  disk_type          = "pd-standard"
  subnetwork         = "projects/${local.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"
  network            = "projects/${local.network_project_id}/global/networks/${var.network}"
  subnetwork_project = local.network_project_id
  service_account = {
    email  = var.bastion_service_account_email
    scopes = ["cloud-platform"]
  }
  enable_shielded_vm   = "false"
  source_image         = ""
  source_image_family  = "debian-9"
  source_image_project = "debian-cloud"
  startup_script       = var.enable_bastion ? data.template_file.startup_script[0].rendered : ""

  tags   = []
  labels = {}

  metadata = merge(
    {},
    {
      enable-oslogin = "TRUE"
    }
  )
}

resource "google_compute_instance_from_template" "bastion_vm" {
  count   = var.enable_bastion ? 1 : 0
  name    = "bastion-vm"
  project = var.project_id
  zone    = local.bastion_zone

  network_interface {
    subnetwork         = "projects/${local.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"
    subnetwork_project = local.network_project_id
  }

  source_instance_template = module.instance_template.self_link
}

module "bastion-nat" {
  count         = var.enable_bastion && var.enable_nat ? 1 : 0
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 1.2"
  project_id    = var.project_id
  region        = var.region
  router        = "bastion-vm"
  network       = "projects/${local.network_project_id}/global/networks/${var.network}"
  create_router = true
}
