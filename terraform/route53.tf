
data "aws_route53_zone" "route_53_zone_for_our_domain__dot_com" {
  name = "leadersaschangeagents.com."
}

resource "aws_route53_record" "dns_alias_record__root_dot_com" {
  zone_id = data.aws_route53_zone.route_53_zone_for_our_domain__dot_com.zone_id
  name    = "leadersaschangeagents.com."
  type    = "A"

  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.distribution_redirects__dot_com.domain_name
    zone_id = aws_cloudfront_distribution.distribution_redirects__dot_com.hosted_zone_id
  }
}

resource "aws_route53_record" "dns_alias_record__www_dot_com" {
  zone_id = data.aws_route53_zone.route_53_zone_for_our_domain__dot_com.zone_id
  name    = "www.leadersaschangeagents.com."
  type    = "A"

  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.distribution_redirects__dot_com.domain_name
    zone_id = aws_cloudfront_distribution.distribution_redirects__dot_com.hosted_zone_id
  }
}


data "aws_route53_zone" "route_53_zone_for_our_domain__dot_org" {
  name = "leadersaschangeagents.org."
}

resource "aws_route53_record" "dns_alias_record__root_dot_org" {
  zone_id = data.aws_route53_zone.route_53_zone_for_our_domain__dot_org.zone_id
  name    = "leadersaschangeagents.org."
  type    = "A"

  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.distribution_redirects__dot_org.domain_name
    zone_id = aws_cloudfront_distribution.distribution_redirects__dot_org.hosted_zone_id
  }
}

resource "aws_route53_record" "dns_alias_record__www_dot_org" {
  zone_id = data.aws_route53_zone.route_53_zone_for_our_domain__dot_org.zone_id
  name    = "www.leadersaschangeagents.org."
  type    = "A"

  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.distribution_redirects__dot_org.domain_name
    zone_id = aws_cloudfront_distribution.distribution_redirects__dot_org.hosted_zone_id
  }
}
