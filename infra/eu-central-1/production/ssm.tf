resource "aws_ssm_parameter" "snowflake_airflow_private_key" {
  name        = "/snowflake/airflow/private-key"
  type        = "SecureString"
  value       = tls_private_key.airflow_key.private_key_pem
  description = "Snowflake private key for Airflow"
  key_id      = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "snowflake_ecs_dbt_private_key" {
  name        = "/snowflake/ecs_dbt/private-key"
  type        = "SecureString"
  value       = tls_private_key.ecs_dbt_key.private_key_pem
  description = "Snowflake private key for ECS dbt"
  key_id      = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "snowflake_ecs_dbt_user" {
  name        = "/snowflake/ecs_dbt/user"
  type        = "SecureString"
  value       = "ECS_DBT_USER"
  description = "Snowflake user for ECS dbt"
  key_id      = "alias/aws/ssm"
}