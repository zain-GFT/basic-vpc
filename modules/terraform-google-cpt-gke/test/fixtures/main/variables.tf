variable "folder_id" {
  type        = string
}

variable "ma_version" {
  type        = string
}

variable "sensitive_workspaces" {
  type        = map(object({
    id = string
    name = string
  }))
}

variable "sensitive_workspace_name" {
  type        = string
}

variable "sensitive_workspace_organization" {
  type        = string
}

variable "sensitive_service_account_email" {
  type        = string
}

variable "main_service_account_email" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
  default     = []
}
