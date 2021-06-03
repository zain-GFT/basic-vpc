module "vpc" {
  source = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = var.subnets

  secondary_ranges = {
        subnet-01 = [
            {
                range_name    = var.subnet.gke_secondary_ip_range.pods.name
                ip_cidr_range = var.subnet.gke_secondary_ip_range.pods.range
            },
            {
                range_name    = var.subnet.gke_secondary_ip_range.services.name
                ip_cidr_range = var.subnet.gke_secondary_ip_range.services.range
            },
        ]
}
