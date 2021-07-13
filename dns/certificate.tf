data "aws_acm_certificate" "botman_web" {
  domain = "botman.app"
}

data "aws_acm_certificate" "botman_engine" {
  domain = "engine.botman.app"
}
