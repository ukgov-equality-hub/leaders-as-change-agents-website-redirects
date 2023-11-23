
resource "aws_cloudfront_cache_policy" "cloudfront_cache_policy" {
  name = "${var.service_name_hyphens}--Cache-Policy"
  min_ttl = 0
  default_ttl = 60
  max_ttl = 600

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
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
    cache_policy_id = aws_cloudfront_cache_policy.cloudfront_cache_policy.id
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
    cache_policy_id = aws_cloudfront_cache_policy.cloudfront_cache_policy.id
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
