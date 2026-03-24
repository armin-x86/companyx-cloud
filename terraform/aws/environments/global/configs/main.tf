locals {
  organisation      = "phrase"
  business_unit     = "infra"
  namespace         = "ateimouri.com"
  root_domain       = "phrase.ateimouri.com"
  secrets_namespace = "team-infra/assignment" # pragma: allowlist secret
  aws_accounts = {
    stg = "216315649159" # Change it to your before applying
    # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#access-logging-bucket-permissions
    lb_account = "156460612806" # LB account in eu-west-1
  }
  ip_cidr_ranges = {
    stg = "10.100.0.0/15"
  }
  # Below is the placeholder to define VPN server or ZTNA solution's shared connectors NGW IPs
  # so whereever we wanted to expose to public, we can at least narrow it down to these trusted IPs
  vpn = {
    wireguard_es = {
      description        = "ES WireGuard server"
      public_cidr_blocks = "51.48.65.26/32"
    },
    wireguard_pl = {
      description        = "PL WireGuard server"
      public_cidr_blocks = "57.128.225.53/32"
    }
  }
}
