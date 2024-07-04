resource "aws_route53_record" "example" {
  zone_id = Z06607023RJWXGXD2ZL6M
  name    = "togaruashok1996.contentecho.in"  # Replace with your subdomain
  type    = "A"
  ttl     = "300"
  records = [aws_eip.example.public_ip]
}
