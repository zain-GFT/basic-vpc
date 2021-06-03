module "gke" {
  source  = "../modules/terraform-google-cpt-gke"

  project_id                 = var.project_id
  region                     = var.primary_region
  name                       = "tekton-test"
  network                    = var.subnet.network
  subnetwork                 = var.subnet.name
  ip_range_pods              = var.subnet.gke_secondary_ip_range.pods.name
  ip_range_services          = var.subnet.gke_secondary_ip_range.services.name

  enable_pod_security_policy = false
  
  default_max_pods_per_node  = 29

  node_pools = [
      {
          name                    = "pool-01"
          max_pods_per_node       = 30
          min_count               = 1
          max_count               = 1
      }
  ]
  master_authorized_networks = concat([
    {
      cidr_block       = var.subnet.ip_cidr_range
      display_name     = "VPC"
    }
  ])
}
