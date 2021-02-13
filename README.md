# Nordloud's Notejam Infrastructure

## Requirements

This project will deploy theinfrastructure into google cloud. Minimum requirements are a GCP account and a permitted user.

### Google Cloud API's
Before Terraform can work and deploy correctly, some GCP API's and Services should be enabled if not yet done.

* Compute Engine API
* Cloud Resource Manager API 
* Cloud Build API
* Cloud Source Repositories API
* Cloud SQL Admin API
* Artifact Registry API
* Cloud Run Admin API
* Service Networking API
* Serverless VPC Access API

## Todo's

* Terragrunt integration for better project structures
* Encrypted remote storage for Terraform state file
* Vault Management integration for secrets in Terraform

## Documentations/Presentation
You can find a latex beamer presentation under ./presentation inside that repoisitory
