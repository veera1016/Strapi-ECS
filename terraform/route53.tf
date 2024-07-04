# Route 53 DNS record for sub-domain
resource "aws_route53_record" "strapi_subdomain" {
  zone_id = "Z06607023RJWXGXD2ZL6M"
  name    = "togaruashok1996.contentecho.in"
  type    = "A"
  ttl = "300"
  records = [aws_eip.strapi_service1_ip.public_ip]   
}
