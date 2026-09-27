## Create keys for each service user
resource "tls_private_key" "ecs_dbt_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_private_key" "airflow_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
