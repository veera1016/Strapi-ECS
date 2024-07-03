resource "aws_route53_zone" "main" {
  name = "contentecho.in"  # Replace with your domain
}

resource "aws_route53_record" "strapi" {
  zone_id = Z06607023RJWXGXD2ZL6M
  name    = "togaruashok1996-ecs"  # Replace with your desired subdomain
  type    = "A"
  alias {
    name                   = aws_ecs_service.strapi.endpoint
    zone_id                = Z06607023RJWXGXD2ZL6M
    evaluate_target_health = true
  }
}
