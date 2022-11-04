# Set common variables for the environment
locals {
  environment    = "stag"
  state_bucket   = "main-us-west-2-stag-tfstate" # Replace with your preferred unique S3 bucket name 
  dynamodb_table = "main-us-west-2-stag-tfstate" # Replace with your preferred dynamodb table name
}