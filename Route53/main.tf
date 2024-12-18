# Get route53 zone details
data "aws_route53_zone" "dns_zone" {
  name = var.domain_name
}  


#A record for the domain name
resource "aws_route53_record" "dns_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.primary_name
  type    = "A"
  ttl     = "300"
  records = [var.webserver_ip]
}

# Cname record for the domain name
resource "aws_route53_record" "cname_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.secondary_name
  type    = "CNAME"
  ttl     = "300"
  records = [var.domain_destination]
}