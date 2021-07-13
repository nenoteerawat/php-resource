output "route53_zone_botman_web_id" {
  value = aws_route53_zone.botman_web.id
}

output "route53_zone_botman_engine_id" {
  value = aws_route53_zone.botman_engine.id
}
