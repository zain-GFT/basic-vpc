# Sensitive Resource Creation

This directory should contain Terraform that creates and manages [Sensitive Cloud Resources](https://confluence/to-be-defined).  

This Terraform is executed during this module's test setup and teardown stages.

## Important Files
* `main.tf`: defines sensitive cloud resources, using the variables defined in `variables.tf`

* `outputs.tf`: defines outputs from the provisioned cloud resources defined in `main.tf` and any other `*.tf` not otherwise listed here.

* `variables.tf`: defines all parameters which are provided by the Terraform pipeline, which are then used to create cloud resources

* `versions.tf`: defines the versions and configuration of all providers and backends