module "test_project" {
  source  = "dbtfe.db.com/PMR/cpt-project/google"
  version = "0.1.0"

  project_name = var.module_name
  lz_version = var.lz_version

  nar_id = var.nar_id
  instance_id = var.instance_id
  environment = var.environment
  
  folder_id = var.folder_id
  organization_id = var.organization_id
  billing_account_id = var.billing_account_id
  
# you must activate any APIs your module requires
  activate_apis = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
    "binaryauthorization.googleapis.com",
    "stackdriver.googleapis.com",
    "iap.googleapis.com",
    "containerscanning.googleapis.com",
    "containeranalysis.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}