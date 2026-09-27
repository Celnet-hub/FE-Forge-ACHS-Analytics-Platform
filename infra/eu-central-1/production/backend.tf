terraform {
  backend "s3" {
    bucket = "fed-engr-dubem-terraform-state"
    key    = "production/forge/terraform.tfstate"
    region = "eu-central-1"
  }
}
