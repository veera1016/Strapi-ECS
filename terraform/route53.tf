resource "aws_route53_zone" "main" {
  name = "contentecho.in"  # Replace with your domain
}

resource "aws_route53_record" "strapi" {
  zone_id = Z06607023RJWXGXD2ZL6M
  name    = "togaruashok1996-Ecs"  # Replace with your desired subdomain
  type    = "A"
  ttl     = 300
  records = [aws_eip.strapi.public_ip]
}

output "route53_zone_id" {
  value = aws_route53_zone.main.id
}
