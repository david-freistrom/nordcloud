#variable "cidr" {
#  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
#  default     = "0.0.0.0/0"
#}

variable "project" {
  description = "The google cloud project name"
  default     = "nordcloud-304401"
} 

variable "region" {
  description = "The region to deploy the infrastructure"
  default = "us-central1"
}

variable "db_username" {
  description = "Username for the PostgreSQL database"
  default     = "notejam"
  sensitive   = true
}

variable "db_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
}