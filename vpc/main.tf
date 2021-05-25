module "vpc" {
  source = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name = "subnet-01"
      subnet_ip = "10.10.20.0/24"
      subnet_region = "us-west1"
    }
  ]
}