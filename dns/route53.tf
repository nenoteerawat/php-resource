resource "aws_route53_zone" "botman_web" {
  name = "botman.app"
  tags = {
    Name = "botman-web"
  }
}

resource "aws_route53_zone" "botman_engine" {
  name = "engine.botman.app"
  tags = {
    Name = "botman-engine"
  }
}

# resource "aws_route53_record" "botman_web_route53_record" {
#   name    = "lb"
#   type    = "A"
#   zone_id = aws_route53_zone.botman_web.id
#   records = []
#   ttl     = 60
# }
