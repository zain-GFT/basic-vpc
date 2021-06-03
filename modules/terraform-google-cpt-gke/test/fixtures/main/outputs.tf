output "project_id" {
    description = "The project to run the tests against"
    value = local.project_id
}

output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke.endpoint
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "location" {
  value = module.gke.location
}

output "client_token" {
  sensitive = true
  value     = base64encode(data.google_client_config.default.access_token)
}

output "ca_certificate" {
  value = module.gke.ca_certificate
  sensitive = true
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "nodepool_name"{
  value = module.gke.node_pools_names
}

