# Set common variables for the environment
locals {
  environment    = "dev"
  state_bucket   = "main-us-east-2-dev-tfstate" # Replace with your preferred unique S3 bucket name 
  dynamodb_table = "main-us-east-2-dev-tfstate" # Replace with your preferred dynamodb table name
}