
data "aws_cloudfront_cache_policy" "cloudfront_cache_policy__managed_caching_disabled" {
  // Previously, we used a Custom Cache Policy for each CloudFront Distribution.
  // But AWS has a quota of 20 custom cache policies per AWS account, with no way of increasing the quota
  // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-limits.html#limits-policies
  // Some of our services need custom cache policies, but others (like this service) can get away with a managed policy without it being too much of a hassle
  // This is very frustrating (because it's nice to be able to tweak the settings exactly as we like) but there's probably nothing we can do about it

  // We're using the "Caching Disabled" policy for this service
  // This service redirects all requests to a different domain
  // We might want to change those redirects in future (if we find more relevant pages to redirect to)
  // The redirect responses are quick and cheap to produce
  // And we doubt the redirects will get much traffic, so there's little point in caching the responses
  name = "Managed-CachingDisabled"
}

locals {
  distribution_origin_id__dot_com = "${var.service_name_hyphens}--redirects-origin--dot-com"
  distribution_origin_id__dot_org = "${var.service_name_hyphens}--redirects-origin--dot-org"
}

resource "aws_cloudfront_distribution" "distribution_redirects__dot_com" {
  // CloudFront distributions have to be created in the us-east-1 region (for some reason!)
  provider = aws.us-east-1

  comment = "${var.service_name_hyphens}--redirects"

  origin {
    domain_name = "example.com"
    origin_id = local.distribution_origin_id__dot_com

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  price_class = "PriceClass_100"

  aliases = [
    "leadersaschangeagents.com",
    "www.leadersaschangeagents.com"
  ]

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.certificate_validation_waiter__dot_com.certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }

  default_root_object = "index.html"

  enabled = true
  is_ipv6_enabled = true

  default_cache_behavior {
    cache_policy_id = data.aws_cloudfront_cache_policy.cloudfront_cache_policy__managed_caching_disabled.id
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.distribution_origin_id__dot_com
    viewer_protocol_policy = "redirect-to-https"
    compress = true

    function_association {
      event_type = "viewer-request"
      function_arn = aws_cloudfront_function.redirect_function.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
}

resource "aws_cloudfront_distribution" "distribution_redirects__dot_org" {
  // CloudFront distributions have to be created in the us-east-1 region (for some reason!)
  provider = aws.us-east-1

  comment = "${var.service_name_hyphens}--redirects"

  origin {
    domain_name = "example.com"
    origin_id = local.distribution_origin_id__dot_org

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  price_class = "PriceClass_100"

  aliases = [
    "leadersaschangeagents.org",
    "www.leadersaschangeagents.org"
  ]

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.certificate_validation_waiter__dot_org.certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }

  default_root_object = "index.html"

  enabled = true
  is_ipv6_enabled = true

  default_cache_behavior {
    cache_policy_id = data.aws_cloudfront_cache_policy.cloudfront_cache_policy__managed_caching_disabled.id
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.distribution_origin_id__dot_org
    viewer_protocol_policy = "redirect-to-https"
    compress = true

    function_association {
      event_type = "viewer-request"
      function_arn = aws_cloudfront_function.redirect_function.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
}

resource "aws_cloudfront_function" "redirect_function" {
  name    = "${var.service_name_hyphens}--redirect-function"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = <<EOT
function handler(event) {
    return {
        statusCode: 302,
        statusDescription: "Found",
        headers: {
            "location": {
                value: 'https://www.gov.uk/government/publications/laca-employer-and-employee-guide-to-inclusion-at-work',
            },
        },
    };
}
EOT
}
