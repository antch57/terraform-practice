# terraform-practice

builds a lambda, rds instance, and api gateway. Secret for master db user stored in secrets manager.

lambda just queries the db. Pulls creds from secret manager.

need vpc and vpc endpoint for secrets manager for this to work.