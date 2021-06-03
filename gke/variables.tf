variable "project_id" {
  type        = string
}

variable "network_name" {
  type        = string
}

variable "primary_region" {
  type = string
}

variable "subnets" {
  type        = list(map(string))
}

variable "subnet" {
  type = object({
    name               = string,
    region             = string,
    id                 = string,
    self_link          = string,
    ip_cidr_range      = string,
    network            = string,
    network_project_id = string,
    gke_secondary_ip_range = object({
      pods = object({
        name  = string,
       range = string
      }),
      services = object({
        name  = string,
        range = string
      }),
    })
  })
}
 
