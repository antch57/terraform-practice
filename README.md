# terraform-practice

builds a lambda, rds instance, and api gateway. Secret for master db user stored in secrets manager.

lambda just queries the db. Pulls creds from secret manager.

need vpc and vpc endpoint for secrets manager and an ecr repo with a docker image for `lambda_1` for this to deploy.

uses s3 backend to store state.


NOTE: the github workflow will build and deploy `lambdas/lambda_1/` on any push to main

initial deploy:
1. setup s3 backend resources
    - `cd remote-state`
    - `terraform init && terraform apply --var-file example.tfvars`

2. deploy infra
    - `terraform init && terraform apply --var-file example.tfvars`

to update stack: `terraform apply --var-file example.tfvars`

