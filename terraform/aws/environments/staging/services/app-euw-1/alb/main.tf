locals {
  tags = merge({
    "${module.config.global.namespace}/application" = replace(data.aws_vpc.app_euw_1.tags["Name"], "vpc-", "")
    },
    module.config.default_tags
  )

  assignment_subdomain = "assingment"
  phrase_host          = "assingment.${trim(module.config.r53_zone, ".")}"
}

module "config" {
  source = "../../../configs"
}

# AVD-AWS-0053 (HIGH): Load balancer is exposed publicly.
# trivy:ignore:avd-aws-0053
# tfsec:ignore:aws-elb-alb-not-public
module "app_euw_1_alb" {
  source = "../../../../../modules/lb/alb"

  alb_name = "${module.config.vpc.app-euw-1.name}-alb-external"
  vpc_id   = data.aws_vpc.app_euw_1.id
  subnets  = data.aws_subnets.app_euw_1_public.ids
  security_groups = [
    module.app_euw_1_alb_vpn_sg.security_group_id,
    module.app_euw_1_alb_external_clients_sg.security_group_id,
    module.app_euw_1_alb_internal_clients_sg.security_group_id,
  ]
  enable_deletion_protection       = true
  enable_cross_zone_load_balancing = true
  internal                         = false

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn = data.aws_acm_certificate.phrase.arn

      fixed_response = {
        content_type = "text/plain"
        message_body = "Not found"
        status_code  = "404"
      }

      rules = {
        https_phrase_nginx = {
          priority = 100
          conditions = [
            {
              host_header = {
                values = [local.phrase_host]
              }
            }
          ]
          actions = [
            {
              type             = "forward"
              target_group_key = "phrase"
            }
          ]
          tags = {
            Name = "https-phrase-nginx"
          }
        }
      }
    }
  }

  target_groups = {
    phrase = {
      name                 = "tg-phrase"
      protocol             = "HTTP"
      port                 = 80
      target_type          = "instance"
      create_attachment    = false
      deregistration_delay = 30
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/phrase"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  }

  additional_target_group_attachments = {
    for idx, id in data.aws_instances.nginx.ids :
    "phrase-${idx}" => {
      target_group_key = "phrase"
      target_id        = id
    }
  }

  tags = local.tags
}

resource "aws_route53_record" "assingment" {
  zone_id = data.aws_route53_zone.phrase.zone_id
  name    = local.assignment_subdomain
  type    = "A"

  alias {
    name                   = module.app_euw_1_alb.alb_dns_name
    zone_id                = module.app_euw_1_alb.alb_zone_id
    evaluate_target_health = true
  }
}
