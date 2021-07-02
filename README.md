# PHP resource

Aws terraform for deploy php website

## Prerequire

### MacOs

Install require program for development

``` shell
brew install warrensbox/tap/tfswitc
brew install pre-commit gawk terraform-docs tflint tfsec coreutils checkov terrascan
```

## Pre-commit setup

``` shell
pre-commit autoupdate
pre-commit install
```

If you encountered with issues. Run this command

``` shell
pre-commit clean
```

## Terraform Run

``` shell
terraform get -update=true
terraform init -backend-config=config/backend.conf
terraform plan -var-file=config/dev.tfvars
terraform apply -var-file=config/dev.tfvars
```
