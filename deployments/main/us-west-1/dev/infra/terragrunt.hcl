/******************************
TERRAGRUNT CONFIGURATIONS
******************************/

/******************************
Include the root terragrunt.hcl configurations gathering together
the needed variables and backend configurations
******************************/
include "root" {
  path = find_in_parent_folders()
}

locals {
  # Expose the base source path
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}