locals {
  common_tags = {
    environment = var.environment
    team        = var.team
    terraform   = true
  }

  snowflake_tags = {
    organization     = "fncwxve"
    account          = "uu56570"
    private_key_path = "terraform_key.p8"
  }
}

