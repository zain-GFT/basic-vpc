## Hardened GKE Cluster

This module defines an opinionated setup of a GKE cluster. The module outlines project configurations, cluster settings, and basic K8s objects that permit a safer-than-default configuration.

The module fixes a set of parameters to values suggested in the [GKE hardening guide](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster), the CIS framework, and other best practices.

The motivation for each setting, and its relation to harderning guides or other recommendations is outlined in `main.tf` as comments over individual settings. When security-relevant settings are available for configuration, recommendations on their settings are documented in the `variables.tf` file.

### Compatibility

This module is meant for use with Terraform 0.12.

### Important

Enabling pod security policy enforcement as a parameter when creating a GKE cluster (enabled by default on the hardened module), will result in Istio's installation failing. For Istio to be installed properly, a PodSecurityPolicy which outlines necessary Istio security controls is used. The manifests for this policy are located in the `examples/manifest` folder.

*Note:* These manifests need to be manually applied (possibly through a bastion), as the hardened module does not enable pipeline connecitvity by default.

---

# Deutsche Bank Module Template

This repository contains the minimum for you as a module author to start your module development.  Please see CPT CE's [Module Authoring](https://confluence.intranet.db.com/display/CPTCE/Module+Authoring) guide for more info.  Once you (the module authoring team) has read and understood this README.md file, you will want to remove and replace it with an updated README.md for the consumers of your module.  See other modules in the PMR for examples: https://dbtfe.db.com/app/PMR/modules


## Module Files

* `auth.tf`: Retrieve authentication token and Configure provider
* `breakglass.tf`: Create logging metrics, notification channels, and an alerting policy for binary authorization break-glass procedures
* `cluster.tf`: Create Container Cluster & Node Pools
* `dns.tf`: Delete default kube-dns configmap & Create new kube-dns confimap
* `firewall.tf`: Match the gke-<CLUSTER>-<ID>-all INGRESS firewall rule created by GKE but for EGRESS, Required for clusters when VPCs enforce a default-deny egress rule and allow GKE master to hit non 443 ports for Webhooks/Admission Controllers https://github.com/kubernetes/kubernetes/issues/79739
* `main.tf`: defines cloud resources that this module produces, using the variables defined in `variables.tf`
* `masq.tf`: Create ip-masq-agent confimap
* `networks.tf`: sets `google_compute_subnetwork.gke_subnetwork` array
* `outputs.tf`: defines outputs from the provisioned cloud resources defined in `main.tf` and any other `*.tf` not otherwise listed here
* `sa.tf`:  creates service account's
* `variables.tf`: defines all parameters which are provided by the module's user (the consumer)
* `versions.tf`: defines the versions and configuration of all providers

* `README.md`: Explain what your module does and how it should be used here.
* `CHANGELOG.md`: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) in this file
* `VERSION`: Keep the [Semantic Version](https://semver.org/spec/v2.0.0.html) for this module in this file.  The pipeline uses this value to publish the module to Terraform Enterprise's Private Module Registry.


## Test Files
* `test`:
    * `fixtures`: 
        * `sensitive`: contains Terraform that sets up the sensitive resources
        * `main`: contains Terraform that sets up main (non-sensitive) resources
    * `integration`: contains Chef Inspec control profiles that verify the fixtures were setup correctly
        * `sensitive`: Inspec profile to verify sensitive resources
            * `controls`: contains Ruby files that define controls/tests
            * `inspec.yml`: defines the inputs to the controls (which are the outputs of the fixtures)
        * `main`:  Similar to `sensitive` except to verify main resources


## Advanced Usage Files
For most modules, these should be left as-is.

* `.kitchen.yml`: controls testing setup, integration, verification, and teardown.
* `.github/workflows/main.yml`: GitHub Action configuration which invokes kitchen. 


**NOTE:** Please read about [Landing Zones](https://confluence.intranet.db.com/display/CPTCE/Landing+Zone+Documentation), to undestand how and where these modules will be used, and especially to understand the split between sensitive and main resources.

---

## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.12.6, <0.14 |
| google-beta | >= 3.32.0, <4.0.0 |
| kubernetes | ~> 1.10, != 1.11.0 |

## Providers

| Name | Version |
|------|---------|
| google | n/a |
| google-beta | >= 3.32.0, <4.0.0 |
| kubernetes | ~> 1.10, != 1.11.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| add\_cluster\_firewall\_rules | Create additional firewall rules | `bool` | `false` | no |
| authenticator\_security\_group | The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com | `string` | `null` | no |
| bastion\_members | List of users, groups, SAs who need access to the bastion host | `list(string)` | `[]` | no |
| bastion\_service\_account\_email | If set, the service account and its permissions will not be created. | `string` | `""` | no |
| binauthz | Binary authorization & break glass procedure settings | <pre>object({<br>    breakglass = object({<br>      email_addresses = list(string)<br>    })<br>  })</pre> | <pre>{<br>  "breakglass": {<br>    "email_addresses": []<br>  }<br>}</pre> | no |
| cloudrun | (Beta) Enable CloudRun addon | `bool` | `false` | no |
| cluster\_autoscaling | Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling) | <pre>object({<br>    enabled             = bool<br>    autoscaling_profile = string<br>    min_cpu_cores       = number<br>    max_cpu_cores       = number<br>    min_memory_gb       = number<br>    max_memory_gb       = number<br>  })</pre> | <pre>{<br>  "autoscaling_profile": "BALANCED",<br>  "enabled": false,<br>  "max_cpu_cores": 0,<br>  "max_memory_gb": 0,<br>  "min_cpu_cores": 0,<br>  "min_memory_gb": 0<br>}</pre> | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | `{}` | no |
| cluster\_telemetry\_type | Available options include ENABLED, DISABLED, and SYSTEM\_ONLY | `string` | `null` | no |
| compute\_engine\_service\_account | Use the given service account for nodes rather than creating a new dedicated service account. | `string` | `""` | no |
| config\_connector | (Beta) Whether ConfigConnector is enabled for this cluster. | `bool` | `false` | no |
| database\_encryption | Application-layer Secrets Encryption settings. The object format is {state = string, key\_name = string}. Valid values of state are: "ENCRYPTED"; "DECRYPTED". key\_name is the name of a CloudKMS key. | `list(object({ state = string, key_name = string }))` | <pre>[<br>  {<br>    "key_name": "",<br>    "state": "DECRYPTED"<br>  }<br>]</pre> | no |
| default\_max\_pods\_per\_node | The maximum number of pods to schedule per node | `number` | `110` | no |
| description | The description of the cluster | `string` | `""` | no |
| disable\_default\_snat | Whether to disable the default SNAT to support the private use of public IP addresses | `bool` | `false` | no |
| dns\_cache | (Beta) The status of the NodeLocal DNSCache addon. | `bool` | `false` | no |
| enable\_bastion | If enabled, a bastion host will be added to connect to the cluster | `bool` | `false` | no |
| enable\_intranode\_visibility | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `false` | no |
| enable\_network\_egress\_export | Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic. | `bool` | `false` | no |
| enable\_pod\_security\_policy | enabled - Enable the PodSecurityPolicy controller for this cluster. If enabled, pods must be valid under a PodSecurityPolicy to be created. | `bool` | `true` | no |
| enable\_private\_endpoint | When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. When false, either endpoint can be used. This field only applies to private clusters, when enable\_private\_nodes is true | `bool` | `true` | no |
| enable\_resource\_consumption\_export | Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. | `bool` | `true` | no |
| enable\_shielded\_nodes | Enable Shielded Nodes features on all nodes in this cluster. | `bool` | `true` | no |
| enable\_vertical\_pod\_autoscaling | Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it | `bool` | `false` | no |
| firewall\_inbound\_ports | List of TCP ports for admission/webhook controllers | `list(string)` | <pre>[<br>  "8443",<br>  "9443",<br>  "15017"<br>]</pre> | no |
| firewall\_priority | Priority rule for firewall rules | `number` | `1000` | no |
| gce\_pd\_csi\_driver | (Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. | `bool` | `true` | no |
| grant\_registry\_access | Grants created cluster-specific service account storage.objectViewer role. | `bool` | `true` | no |
| horizontal\_pod\_autoscaling | Enable horizontal pod autoscaling addon | `bool` | `true` | no |
| http\_load\_balancing | Enable httpload balancer addon. The addon allows whoever can create Ingress objects to expose an application to a public IP. Network policies or Gatekeeper policies should be used to verify that only authorized applications are exposed. | `bool` | `true` | no |
| initial\_node\_count | The number of nodes to create in this cluster's default node pool. | `number` | `0` | no |
| ip\_range\_pods | The _name_ of the secondary subnet ip range to use for pods | `string` | n/a | yes |
| ip\_range\_services | The _name_ of the secondary subnet range to use for services | `string` | n/a | yes |
| issue\_client\_certificate | Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive! | `bool` | `false` | no |
| istio | (Beta) Enable Istio addon | `bool` | `false` | no |
| istio\_auth | (Beta) The authentication type between services in Istio. | `string` | `"AUTH_MUTUAL_TLS"` | no |
| kubernetes\_version | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. The module enforces certain minimum versions to ensure that specific features are available. | `string` | `null` | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_end\_time | Time window specified for recurring maintenance operations in RFC3339 format | `string` | `""` | no |
| maintenance\_recurrence | Frequency of the recurring maintenance window in RFC5545 format. | `string` | `""` | no |
| maintenance\_start\_time | Time window specified for daily maintenance operations in RFC3339 format | `string` | `"05:00"` | no |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation to use for the hosted master network | `string` | `"10.0.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| name | The name of the cluster | `string` | n/a | yes |
| network | The VPC network to host the cluster in | `string` | n/a | yes |
| network\_project\_id | The project ID of the shared VPC's host (for shared vpc support) | `string` | `""` | no |
| node\_pools | List of maps containing node pools | `list(map(string))` | <pre>[<br>  {<br>    "name": "default-node-pool"<br>  }<br>]</pre> | no |
| node\_pools\_labels | Map of maps containing node labels by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_metadata | Map of maps containing node metadata by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_oauth\_scopes | Map of lists containing node oauth scopes by node-pool name | `map(list(string))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| node\_pools\_tags | Map of lists containing node network tags by node-pool name | `map(list(string))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| node\_pools\_taints | Map of lists containing node taints by node-pool name | `map(list(object({ key = string, value = string, effect = string })))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | n/a | yes |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` | no |
| registry\_project\_id | Project holding the Google Container Registry. If empty, we use the cluster project. If grant\_registry\_access is true, storage.objectViewer role is assigned on this project. | `string` | `""` | no |
| release\_channel | (Beta) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"REGULAR"` | no |
| resource\_usage\_export\_dataset\_id | The dataset id for which network egress metering for this cluster will be enabled. If enabled, a daemonset will be created in the cluster to meter network egress traffic. | `string` | `""` | no |
| sandbox\_enabled | (Beta) Enable GKE Sandbox (Do not forget to set `image_type` = `COS_CONTAINERD` to use it). | `bool` | `false` | no |
| skip\_provisioners | Flag to skip all local-exec provisioners. It breaks `stub_domains` and `upstream_nameservers` variables functionality. | `bool` | `false` | no |
| stub\_domains | Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server | `map(list(string))` | `{}` | no |
| subnetwork | The subnetwork to host the cluster in | `string` | n/a | yes |
| upstream\_nameservers | If specified, the values replace the nameservers taken by default from the node’s /etc/resolv.conf | `list(string)` | `[]` | no |
| zones | The zones to host the cluster in | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | Cluster ca certificate (base64 encoded) |
| cloudrun\_enabled | Whether CloudRun enabled |
| dns\_cache\_enabled | Whether DNS Cache enabled |
| endpoint | Cluster endpoint |
| horizontal\_pod\_autoscaling\_enabled | Whether horizontal pod autoscaling enabled |
| http\_load\_balancing\_enabled | Whether http load balancing enabled |
| identity\_namespace | Workload Identity namespace |
| intranode\_visibility\_enabled | Whether intra-node visibility is enabled |
| istio\_enabled | Whether Istio is enabled |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| logging\_service | Logging service used |
| master\_authorized\_networks\_config | Networks from which access to master is permitted |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation used for the hosted master network |
| master\_version | Current master kubernetes version |
| min\_master\_version | Minimum master kubernetes version |
| monitoring\_service | Monitoring service used |
| name | Cluster name |
| network\_policy\_enabled | Whether network policy enabled |
| node\_pools\_names | List of node pools names |
| node\_pools\_versions | List of node pools versions |
| peering\_name | The name of the peering between this cluster and the Google owned VPC. |
| pod\_security\_policy\_enabled | Whether pod security policy is enabled |
| region | Cluster region |
| release\_channel | The release channel of this cluster |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| type | Cluster type (regional / zonal) |
| vertical\_pod\_autoscaling\_enabled | Whether veritical pod autoscaling is enabled |
| zones | List of zones in which the cluster resides |