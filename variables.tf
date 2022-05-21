locals {
  cdn_domain_name    = format("%s.%s", var.subdomain, var.domain_name)
  wildcard_domain    = format("*.%s", local.cdn_domain_name)
  cf_origin_id       = format("app_%s", local.cdn_domain_name)
}

variable "domain_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "labmda_origin_name" {
  type = string # "origin-request-login-preview"
}

variable "region" {
  type = string
}