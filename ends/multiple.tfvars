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
  name
  region
  id
  self_link
  ip_cidr_range = 
  network =
  network_project_id =
  gke_secondary_ip_range = {
    pods = {
      name   = "pods"
      range  = "10.10.20.0/24"
    },
    services = {
      name   = "services"
      range  = "192.168.64.0/24"
    },
  }
}
