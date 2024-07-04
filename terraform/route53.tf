resource "aws_route53_zone" "main" {
  name = "contentecho.in"  # Replace with your domain
}

resource "aws_route53_record" "strapi_subdomain" {
  zone_id = aws_route53_zone.main.id
  name    = "togaruashok1996Ecs"  # Replace with your desired subdomain
  type    = "A"
  ttl     = 300
  records = [aws_eip.strapi.public_ip]  # Use the correct EIP resource here
}

output "route53_zone_id" {
  value = aws_route53_zone.main.id
}
