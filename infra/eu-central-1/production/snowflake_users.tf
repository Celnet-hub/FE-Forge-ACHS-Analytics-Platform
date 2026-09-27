###### SNOWFLAKE USERS AND ROLES ######
###### ECS_DBT ROLE AND USER ######
resource "snowflake_account_role" "ecs_dbt_role" {
  provider = snowflake.useradmin
  name     = "ECS_DBT_ROLE"
  comment  = "Role for ECS dbt tasks"
}


resource "snowflake_grant_account_role" "grant_tf_role_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.ecs_dbt_role.name
  parent_role_name = "SYSADMIN"
}


resource "snowflake_user" "ecs_dbt_user" {
  provider          = snowflake.useradmin
  name              = "ECS_DBT_USER"
  default_warehouse = snowflake_warehouse.dbt_compute.name
  default_role      = snowflake_account_role.ecs_dbt_role.name
  default_namespace = "${snowflake_database.achs_analytics.name}.${snowflake_schema.staging.fully_qualified_name}"
  rsa_public_key    = substr(tls_private_key.ecs_dbt_key.public_key_pem, 27, 398)
}

resource "snowflake_grant_account_role" "grants_ecs_dbt_user_to_ecs_dbt_role" {
  provider  = snowflake.useradmin
  role_name = snowflake_account_role.ecs_dbt_role.name
  user_name = snowflake_user.ecs_dbt_user.name
}



##### AIRFLOW ROLE AND USER ######
resource "snowflake_account_role" "airflow_role" {
  provider = snowflake.useradmin
  name     = "AIRFLOW_ROLE"
  comment  = "Role for Airflow tasks"
}

resource "snowflake_grant_account_role" "grant_airflow_role_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.airflow_role.name
  parent_role_name = "SYSADMIN"
}


resource "snowflake_user" "airflow_user" {
  provider          = snowflake.useradmin
  name              = "AIRFLOW_USER"
  default_warehouse = snowflake_warehouse.dbt_compute.name
  default_role      = snowflake_account_role.airflow_role.name
  default_namespace = "${snowflake_database.achs_analytics.name}.${snowflake_schema.staging.fully_qualified_name}"
  rsa_public_key    = substr(tls_private_key.airflow_key.public_key_pem, 27, 398)
}

resource "snowflake_grant_account_role" "grant_airflow_user_to_airflow_role" {
  provider  = snowflake.useradmin
  role_name = snowflake_account_role.airflow_role.name
  user_name = snowflake_user.airflow_user.name
}


