data "google_client_config" "default" {
  provider = google-beta
}

/******************************************
  Configure provider
 *****************************************/
provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${local.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
}
