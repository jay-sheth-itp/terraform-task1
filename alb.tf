module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "jay-alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.web_sg.security_group_id]
  
  target_groups = [
    {
      name_prefix      = "jay-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness = {"enabled" = true, "type" = "lb_cookie"}
      # health check
      health_check = {
        matcher = "200-399"
        path    = "/icons/"
        interval = 120
        timeout = 30
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      action = {
        type = "redirect"
        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }

      }
      target_group_index = 0
    }
  ]

   https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:us-east-1:587172484624:certificate/4a382046-f0f6-4203-bfe5-a6319c62c318"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
    Name        = "jay sheth"
    Owner       = "jay.sheth@intuitive.cloud"
  }
}
  