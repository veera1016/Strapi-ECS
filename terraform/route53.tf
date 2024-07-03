resource "aws_route53_zone" "main" {
  name = "contentecho.in"  # Replace with your domain
}

resource "aws_route53_record" "strapi" {
  zone_id = aws_route53_zone.main.id  # Dynamically reference the zone ID from aws_route53_zone.main
  name    = "togaruashok1996-ecs"  # Replace with your desired subdomain
  type    = "A"
  ttl     = 300
  records = [aws_eip.strapi.public_ip]  # Reference the Elastic IP created in ecs.tf
}

output "route53_zone_id" {
  value = aws_route53_zone.main.id
}
