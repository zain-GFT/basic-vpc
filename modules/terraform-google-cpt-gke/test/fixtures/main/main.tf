# load the sensitive workspace's state
# the Terraform in test/fixtures/sensitive used this workspace to create the project we need
data "terraform_remote_state" "sensitive_state" {
  backend = "remote"
  config = {
    hostname = "dbtfe.db.com"
    organization = var.sensitive_workspace_organization
    workspaces = {
      name = var.sensitive_workspace_name
    }
  }
}

resource "random_string" "gke_name_random" {
  special = false
  upper   = false
  length  = 4
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals{
  project_id            = data.terraform_remote_state.sensitive_state.outputs.project_id
  project_number        = data.terraform_remote_state.sensitive_state.outputs.project_number
  service_account       = data.terraform_remote_state.sensitive_state.outputs.service_account

  network_self_link     = data.terraform_remote_state.sensitive_state.outputs.network_self_link
  network_name          = data.terraform_remote_state.sensitive_state.outputs.network_name
  subnet_self_link      = data.terraform_remote_state.sensitive_state.outputs.subnet_self_link
  subnet_name           = data.terraform_remote_state.sensitive_state.outputs.subnet_name
  
  subnet_ip_cidr_range  = data.terraform_remote_state.sensitive_state.outputs.subnet_ip_cidr_range

  subnet_first_range    = data.terraform_remote_state.sensitive_state.outputs.subnet_first_range
  subnet_second_range   = data.terraform_remote_state.sensitive_state.outputs.subnet_second_range

  cluster_name          = "hardened-gke-test-${random_string.suffix.result}"
}

# invoke module
module "gke" {
  source = "../../.." # path to the root of this project's
  project_id                      = local.project_id
  name                            = local.cluster_name
  regional                        = true
  compute_engine_service_account  = data.terraform_remote_state.sensitive_state.outputs.service_account
  region                          = var.region
  network                         = local.network_name
  subnetwork                      = local.subnet_name
  ip_range_pods                   = local.subnet_first_range
  ip_range_services               = local.subnet_second_range
  enable_private_endpoint         = true
  master_ipv4_cidr_block          = "172.8.0.0/28"
  default_max_pods_per_node       = 30
  grant_registry_access           = true
  enable_bastion                  = true
  enable_nat                      = true
  skip_provisioners               = true
  bastion_service_account_email   = local.service_account

  cluster_resource_labels = {
    "cluster_type" = "hardened"
  }

  node_pools = [
    {
      name              = "pool-01"
      min_count         = 1
      max_count         = 1
      local_ssd_count   = 0
      disk_size_gb      = 100
      disk_type         = "pd-standard"
      image_type        = "COS"
      auto_repair       = true
      auto_upgrade      = true
      preemptible       = false
      max_pods_per_node = 30
      boot_disk_kms_key = data.terraform_remote_state.sensitive_state.outputs.kmskey_self_link_map["gke"]
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  node_pools_metadata = {
    all = {
      "block-project-ssh-keys" = "TRUE"
    }
  }

  node_pools_labels = {
    all = {
      "node_type" = "hardened"
    }
  }

  master_authorized_networks = concat([
    {
      cidr_block   = local.subnet_ip_cidr_range
      display_name = "VPC"
    }
  ])

  enable_intranode_visibility = true

  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = data.terraform_remote_state.sensitive_state.outputs.kmskey_self_link_map["gke"]
  }]

  istio = true

  issue_client_certificate = true
  
  binauthz = {
    breakglass = {
      email_addresses = []
    }
  }

}

data "google_client_config" "default" {
}
