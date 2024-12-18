resource "aws_acm_certificate" "pokersain-dev" {
    domain_name       = var.domain_name
    subject_alternative_names = [var.alternative_name]
    validation_method = "DNS"
    lifecycle {
        create_before_destroy = true
    }
    tags = {
        Name = var.project-name
    }
}

#get details about a route53 hosted zone

data "aws_route53_zone" "route53_zone" {
    name = var.domain_name
    private_zone = false
}


# Route53 DNS validation
resource "aws_route53_record" "pokersain-dev-certificate-validation" {
    for_each = {
        for dvo in aws_acm_certificate.pokersain-dev.domain_validation_options: dvo.domain_name => {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }
    }
    allow_overwrite = true
    name = each.value.name
    records = [each.value.record]
    ttl = 60
    type = each.value.type
    zone_id = data.aws_route53_zone.route53_zone.zone_id
}

# ACM certificate validation
resource "aws_acm_certificate_validation" "pokersain-dev" {
    certificate_arn = aws_acm_certificate.pokersain-dev.arn
    validation_record_fqdns = [for record in aws_route53_record.pokersain-dev-certificate-validation : record.fqdn]
}