# MFT Platform Basic Terraform
# test
# providers.tf - Provider declarations

terraform {
  required_version = "~> 0.11.3"
}

// provider "aws" {
//   region = "us-west-2"


//   assume_role {
//     role_arn     = "arn:aws:iam::${var.account}:role/${var.atlantis_role}"
//     session_name = "${var.atlantis_user}"
//   }
// }


// terraform {
//   required_version = "~> 0.11.3"


//   backend "s3" {
//     bucket               = "eap-int-prod-tf-statefiles-us-west-2"
//     workspace_key_prefix = "mft-serverless-template"
//     key                  = "mft/mft-config-migration.tfstate"
//     region               = "us-west-2"
//     encrypt              = "true"
//     dynamodb_table       = "eap-infrastructure-tfstate"
//   }
// }

