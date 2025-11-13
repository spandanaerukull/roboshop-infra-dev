
# this is for creating acm certificate 
resource "aws_acm_certificate" "spandanas" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}


# this is for creating for r53 records  for acm certificate validation
# The Route 53 record in ACM acts as a proof of domain ownership.
resource "aws_route53_record" "spandanas" {
  for_each = {
    for dvo in aws_acm_certificate.spandanas.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true # this will allow to overwrite the existing record if it exists
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}


# this is for validating the acm certificate using r53 records
resource "aws_acm_certificate_validation" "spandanas" {
  certificate_arn         = aws_acm_certificate.spandanas.arn
  validation_record_fqdns = [for record in aws_route53_record.spandanas : record.fqdn]
}