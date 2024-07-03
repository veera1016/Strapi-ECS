resource "aws_route53_zone" "main" {
  name = "contentecho.in"  # Replace with your domain
}

resource "aws_route53_record" "strapi" {
  zone_id = "Z06607023RJWXGXD2ZL6M"  # Replace with your actual hosted zone ID
  name    = "togaruashok1996"  # Replace with your desired subdomain
  type    = "A"
  alias {
    name                   = aws_ecs_service.strapi.network_configuration[0].assign_public_ip
    zone_id                = "Z06607023RJWXGXD2ZL6M"  # Replace with your actual hosted zone ID
    evaluate_target_health = true
  }
}

output "route53_zone_id" {
  value = aws_route53_zone.main.id
}
