variable "project_id" {
  type        = string
}

variable "primary_region" {
  type        = string
}

variable "network_name" {
  type        = string
}

variable "subnets" {
  type        = list(map(string))
}

variable "gke_secondary_ip_range" {
  type        = map(list(object({
                range_name = string, 
                ip_cidr_range = string})))
}
