project_id       = "iac-orchestration-dev-proj"

network_name     = "iac-orchestration-vpc"

subnets          = [
  {
    subnet_name = "subnet-01"
    subnet_ip = "10.10.20.0/24"
    subnet_region = "europe-west2"
  }
]

subnet = {
  name               = "subnet-01"
  region             = "europe-west2"
  id                 = "projects/iac-orchestration-dev-proj/regions/europe-west2/subnetworks/subnet-01"
  self_link          = "https://www.googleapis.com/compute/v1/projects/iac-orchestration-dev-proj/regions/europe-west2/subnetworks/subnet-01"
  ip_cidr_range      = "10.10.20.0/24"
  network            = "iac-orchestration-vpc"
  network_project_id = "iac-orchestration-dev-proj"
  gke_secondary_ip_range = {
    pods = {
      name   = "pods"
      range  = "192.168.32.0/24"
    },
    services = {
      name   = "services"
      range  = "192.168.64.0/24"
    },
  }
}
