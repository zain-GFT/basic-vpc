locals {
  cluster_name           = "tekton"
  project_id             = "iac-orchestration-dev-proj"
  region                 = "europe-west2"
  master_ipv4_cidr_block = "172.16.0.0/28"
  network_name           = "iac-orchestration-vpc"
  subnet_name            = "subnet-01"
  secondary_range_pods   = "pods"
  secondary_range_svcs   = "services"
  nodes_disk_size        = 120
  default_pods_per_node  = 64
  node_pool_max_pods     = 64
  node_pool_min_nodes    = 1
  node_pool_max_nodes    = 3
  node_machine_type      = "n1-standard-2"
}

data "google_compute_subnetwork" "subnet" {
  project = local.project_id
  name    = local.subnet_name
  region  = local.region
}

data "google_container_engine_versions" "k8s_version" {
  location = local.region
  project  = local.project_id
}

module "gke" {
  source  = "../modules/terraform-google-cpt-gke"

  project_id                 = local.project_id
  region                     = local.region
  name                       = local.cluster_name
  network                    = local.network_name
  subnetwork                 = local.subnet_name
  ip_range_pods              = local.secondary_range_pods
  ip_range_services          = local.secondary_range_svcs
  enable_pod_security_policy = false
  master_ipv4_cidr_block     = local.master_ipv4_cidr_block
  enable_shielded_nodes      = true
  kubernetes_version         = data.google_container_engine_versions.k8s_version.release_channel_default_version["REGULAR"]
  
  enable_bastion             = true

  default_max_pods_per_node  = local.default_pods_per_node
  # ignore scrips in module to echo cluster has been created
  skip_provisioners = true

  
  node_pools = [
      {
          name               = "pool-01"
          max_pods_per_node  = local.node_pool_max_pods
          min_count          = local.node_pool_min_nodes
          max_count          = local.node_pool_max_nodes
          enable_secure_boot = true
          //service_account
          image_type         = "COS"
          auto_repair        = true
          auto_upgrade       = true
          preemptible        = false
          disk_size_gb       = local.nodes_disk_size
          machine_type       = local.node_machine_type
      }
  ]
  master_authorized_networks = concat([
    {
      cidr_block       = data.google_compute_subnetwork.subnet.ip_cidr_range
      display_name     = "VPC"
    },
    {
      cidr_block       = data.google_compute_subnetwork.subnet.secondary_ip_range[index(data.google_compute_subnetwork.subnet.secondary_ip_range.*.range_name, "pods")].ip_cidr_range
      display_name     = "Pods"
    },
    {
      cidr_block       = data.google_compute_subnetwork.subnet.secondary_ip_range[index(data.google_compute_subnetwork.subnet.secondary_ip_range.*.range_name, "services")].ip_cidr_range
      display_name     = "Services"
    },
    
  ])
}
