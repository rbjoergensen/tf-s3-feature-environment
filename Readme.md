# S3 feature environments
Terraform module for creating an S3 bucket for hosting dynamic feature environments. Each folder in the bucket will correspond to a subdomain on the hostname.<br/>
This would mean if we had a S3 folder structure looking like this.

- v1-0-0
    - index.html
- v1-0-1
    - index.html
- v2-0-0
    - index.html
- v2-0-1
    - index.html

We would have the different versions of our app hosted on the following domains if we base it on the below example.

- v1-0-0.myapp.callofthevoid.dk
- v1-0-1.myapp.callofthevoid.dk
- v2-0-0.myapp.callofthevoid.dk
- v2-0-1.myapp.callofthevoid.dk

## Example
``` hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}

provider "aws" {
  alias  = "frankfurt"
  region = "eu-central-1"
}

module "bucket" {
  providers = {
    aws = aws.frankfurt
  }
  source             = "git::https://github.com/rbjoergensen/tf-s3-feature-environment.git?ref=v0"
  domain_name        = "callofthevoid.dk"
  subdomain          = "myapp"
  bucket_name        = "myapp-preview-environment"
  labmda_origin_name = "origin-request-myapp-preview"
  region             = "eu-central-1"
}
```
