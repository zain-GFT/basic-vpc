variable "module_name" {
  type        = string
}

variable "nar_id" {
  type        = string
}

variable "instance_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "ma_version" {
  type        = string
}

variable "organization_id" {
  type = string
}

variable "billing_account_id" {
  type = string
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

variable "lz_version" {
  type        = string
}




variable "service_account_email" {
  type        = string
  description = <<EOF
  The email address of the service account that requires roles/`cloudkms.admin`.
  This service account is normally the CICD service account that runs this module
  EOF
  default     = ""
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "key_rotation_period" {
  description = <<EOF
The rotation period in seconds that when passed a new key or version will be created
and the new key version will become the primary key.
Period defaults to 90 days as recommended by `CIS Google Cloud Platform Foundation Benchmark
v1.1.0-03-11-2020`
EOF
  type        = string
  default     = "7776000s"
}

variable "key_algorithm" {
  description = "The algorithm to use when creating a version based on this template"
  type        = string
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "key_protection_level" {
  description = "The immutable protection level used when creating a crypto key version"
  type        = string
  default     = "SOFTWARE"
  validation {
    condition     = contains(["SOFTWARE", "HSM"], var.key_protection_level)
    error_message = "The key_protection_level value can only be one of two values: SOFTWARE or HSM."
  }
}

variable "kms_labels" {
  description = "A map of labels to apply to a KMS key"
  type        = map
  default     = {}
}

variable "bastion_members" {
  description = "A List of users and groups that are allowed to use IAP TCP forwarding for all VM instances in this project"
  type    = list(string)
  default = ["user:tyler.allen@gcp.deuba.com"] 
}

