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

## SSH key generate

``` shell
ssh-keygen -t rsa -q -f {key-name} -N ''
```

## RDS MYSQL
```
    mysql -h php-service.cmw6el8utq3k.ap-southeast-1.rds.amazonaws.com -P 3306 -u admin -p
```

## Info
```
frontend: http://ec2-13-213-187-49.ap-southeast-1.compute.amazonaws.com/
backend:  http://ec2-46-137-244-237.ap-southeast-1.compute.amazonaws.com/
```
