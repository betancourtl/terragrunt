/******************************
Variables to be used with the infrastructure code
******************************/
variable "account_name" {
  type        = string
  description = "The name of the account"
}

variable "aws_region" {
  type        = string
  description = "The name of the AWS region"
}

variable "environment" {
  type        = string
  description = "Name of the environment/stack"
}

/******************************
More variables in the actual file, please check the Github repo
******************************/
