project_id       = "zain-315011"

network_name     = "iac-orchestration-vpc"

subnets          = [
  {
    subnet_name = "subnet-01"
    subnet_ip = "10.10.20.0/24"
    subnet_region = "europe-west2"
  }
]

secondary_ranges = {
  subnet-01 = [
    {
      range_name    = "subnet-01-secondary-01"
      ip_cidr_range = "192.168.64.0/24"
    },
  ]
}
