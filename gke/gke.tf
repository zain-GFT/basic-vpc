module "gke" {
  source  = "../modules/terraform-google-cpt-gke"

  project_id                 = var.project_id
  region                     = var.primary_region
  name                       = "tekton-test"
  network                    = var.network_name
  subnetwork                 = var.subnets.subnet_name
  ip_range_pods              = var.subnets.gke_secondary_ip_range.pods.name
  ip_range_services          = var.subnets.gke_secondary_ip_range.subnet-01.name

  enable_pod_security_policy = false

  node_pools = [
      {
          name               = "pool-01"
      }
  ]
}