# S3 backend for Terraform

Createe a s3 bucket and dynamodb table to use as terraform backend.

* dynamodb_table_name = terraform-lock
* s3_bucket_name = <account_id>-terraform-states

## Usage

``` shell
# make sure you are on the right aws account
pip install awscli
aws s3 ls

# Dry-run
terraform init
terraform plan -var-file=../config/${env}.tfvars

# apply the change
terraform apply var-file=../config/${env}.tfvars
```
