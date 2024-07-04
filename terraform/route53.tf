# Create a Route 53 hosted zone (if you don't have one)
resource "aws_route53_zone" "example" {
  name = "contentecho.in."  # Replace with your domain name
}

# Create a Route 53 A record pointing to your ECS service
resource "aws_route53_record" "example" {
  zone_id = Z06607023RJWXGXD2ZL6M
  name    = "togaruashok1996.contentecho.in"  # Replace with your subdomain
  type    = "A"
  ttl     = "300"
  records = [aws_ecs_service.example.network_configuration[0].assign_public_ip]  # Or a fixed IP if you're using a static IP setup
}
