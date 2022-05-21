data "aws_route53_zone" "external" {
  name = format("%s.", var.domain_name)
}

resource "aws_route53_record" "wildcard_cdn" {
  zone_id = data.aws_route53_zone.external.zone_id
  name    = local.wildcard_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "naked_cdn" {
  zone_id = data.aws_route53_zone.external.zone_id
  name    = local.cdn_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}