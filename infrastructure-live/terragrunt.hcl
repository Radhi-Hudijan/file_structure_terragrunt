# TERRAGRUNT CONFIGURATION


locals {
    # automatically load the accout- level variables
    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

    # # automatically load the region-level variables
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

    # automatically load the environment-level variables
    environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

    # Extract the variables from the account, region, and environment levels
    account_name = local.account_vars.locals.account_name
    region_name = local.region_vars.locals.region_name
    account_id   = local.account_vars.locals.aws_account_id
     }
 
# Generate an AWS provider configuration block

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
    region = "${local.region_name}"

 # optional: specify the AWS profile to use
    allowed_account_ids = ["${local.account_id}"]
    }
EOF
}

# configure the remote state to store the state file in an S3 bucket

remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
    config = {
        bucket         = "${get_env("TG_BUCKET_PREFIX","")}terragrunt-example-tf-state-${local.account_name}-${local.region_name}"
        key            = "${path_relative_to_include()}/terraform.tfstate"
        region         = "${local.region_name}"
        encrypt        = true
        dynamodb_table = "tf-lock-table"
}
}

# Configure what repos to search when you run 'terragrunt catalog'
catalog {
  urls = [
    "https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example",
    "https://github.com/gruntwork-io/terraform-aws-utilities",
    "https://github.com/gruntwork-io/terraform-kubernetes-namespace"
  ]
}

# Merge the variables from the account, region, and environment levels
inputs = merge(
    local.account_vars.locals,
    local.region_vars.locals,
    local.environment_vars.locals
)