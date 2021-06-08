locals {
  project_id              = "iac-orchestration-dev-proj"
  region                  = "europe-west2"
  network_name            = "iac-orchestration-vpc"
  #SUBNET 01
  subnet_01_name          = "subnet-01"
  subnet_01_range         = "192.168.0.0/24" //254
  subnet_01_sec_pods_name = "pods"
  subnet_01_sec_pods_cidr = "192.168.8.0/22" //1022
  subnet_01_sec_svcs_name = "services"
  subnet_01_sec_svcs_cidr = "192.168.1.0/24" //254
}


module "vpc" {
  source = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = local.project_id
  network_name = local.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
        subnet_name   = local.subnet_01_name
        subnet_ip     = local.subnet_01_range
        subnet_region = local.region
    }
  ]

  secondary_ranges = {
        "${local.subnet_01_name}" = [
            {
                range_name    = local.subnet_01_sec_pods_name
                ip_cidr_range = local.subnet_01_sec_pods_cidr
            },
            {
                range_name    = local.subnet_01_sec_svcs_name
                ip_cidr_range = local.subnet_01_sec_svcs_cidr
            },
        ]
}
}
