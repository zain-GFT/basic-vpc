# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.2]
- Added log_config to compute firewall

## [0.3.1]
### Changed
- Removed upper constraint on terraform version
- Fixed what seems like some variable confusion

## [0.3.0]
- `bastion.tf`: Usage of network and subnetwork names rather than links
- `bastion.tf`: Set subnetwork_project to the host project id (network_project_id)
- `variables.tf`: Removed network_link and subnetwork_link

## [0.2.2]
- `bastion.tf`: Added additional toggle to disable bastion NAT

## [0.2.1]
- `bastion.tf`: Disable startup_script if empty in instance_template
- `bastion.tf`: Disable bastion-nat if bastion is disabled

## [0.2.0]
### Added
- `auth.tf`: Retrieve authentication token and Configure provider
- `cluster.tf`: Create Container Cluster & Node Pools
- `dns.tf`: Delete default kube-dns configmap & Create new kube-dns confimap
- `firewall.tf`: Match the gke-<CLUSTER>-<ID>-all INGRESS firewall rule created by GKE but for EGRESS, Required for clusters when VPCs enforce a default-deny egress rule and allow GKE master to hit non 443 ports for Webhooks/Admission Controllers https://github.com/kubernetes/kubernetes/issues/79739
- `masq.tf`: Create ip-masq-agent confimap
- `networks.tf`: sets `google_compute_subnetwork.gke_subnetwork` array
- `sa.tf`:  creates service account's
- `/scripts`: containing scripts used through module
- Activate API's: "compute.googleapis.com" & "container.googleapis.com" in sensitive fixture
- Sensitive fixture to create SA
- Main fixture creates network
- Main test fixture based on GKE example
- Main inspec integration tests based on example

### Changed
- Updated readme to include variable descriptions and version requirements


## 0.0.1

### Features

* Initial Kitchen Test Setup
