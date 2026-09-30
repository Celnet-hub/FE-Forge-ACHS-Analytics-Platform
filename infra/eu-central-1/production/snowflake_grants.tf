####### Permissions for ECS_DBT_USER #######

# Grant usage on the warehouse
resource "snowflake_grant_privileges_to_account_role" "grant_usage_warehouse_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.dbt_compute.name
  }
}

# Grant usage on the database
resource "snowflake_grant_privileges_to_account_role" "grant_usage_achs_analytics_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.achs_analytics.name
  }
}

# Grant usage on the staging schema
resource "snowflake_grant_privileges_to_account_role" "grant_usage_staging_schema_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema {
    schema_name = snowflake_schema.staging.fully_qualified_name
  }
}

# Grant select on all and future tables in the staging schema
resource "snowflake_grant_privileges_to_account_role" "grant_select_on_staging_schema_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.staging.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_select_on_future_staging_tables_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.staging.fully_qualified_name
    }
  }
}


# Grant usage on the silver schema
resource "snowflake_grant_privileges_to_account_role" "grant_usage_silver_schema_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE", "CREATE TABLE"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema {
    schema_name = snowflake_schema.silver.fully_qualified_name
  }
}

# Grant select and insert on all and future tables in the silver schema
resource "snowflake_grant_privileges_to_account_role" "grant_select_on_silver_schema_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT", "INSERT"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.silver.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_select_insert_on_future_silver_tables_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT", "INSERT"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.silver.fully_qualified_name
    }
  }
}

# Grant usage on the gold schema
resource "snowflake_grant_privileges_to_account_role" "grant_usage_gold_schema_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema {
    schema_name = snowflake_schema.gold.fully_qualified_name
  }
}

# Grant select and insert on all and future tables in the gold schema
resource "snowflake_grant_privileges_to_account_role" "grant_select_on_gold_schema_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT", "INSERT"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.gold.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_select_insert_on_future_gold_tables_to_ecs_dbt_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT", "INSERT"]
  account_role_name = snowflake_account_role.ecs_dbt_role.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.gold.fully_qualified_name
    }
  }
}


####### Permissions for AIRFLOW_ROLE #######

# Grant usage on the warehouse
resource "snowflake_grant_privileges_to_account_role" "grant_usage_warehouse_to_airflow_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.airflow_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.dbt_compute.name
  }
}

# Grant usage on the database
resource "snowflake_grant_privileges_to_account_role" "grant_usage_achs_analytics_to_airflow_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.airflow_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.achs_analytics.name
  }
}

# Grant usage on the staging schema
resource "snowflake_grant_privileges_to_account_role" "grant_usage_staging_schema_to_airflow_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.airflow_role.name
  on_schema {
    schema_name = snowflake_schema.staging.fully_qualified_name
  }
}

# Grant select and insert on all existing tables in the staging schema
resource "snowflake_grant_privileges_to_account_role" "grant_select_insert_on_staging_tables_to_airflow_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT", "INSERT"]
  account_role_name = snowflake_account_role.airflow_role.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.staging.fully_qualified_name
    }
  }
}

# Grant select and insert on future tables created in the staging schema
resource "snowflake_grant_privileges_to_account_role" "grant_select_insert_on_future_staging_tables_to_airflow_role" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT", "INSERT"]
  account_role_name = snowflake_account_role.airflow_role.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.staging.fully_qualified_name
    }
  }
}

# Grant usage on the raw data external stage
resource "snowflake_grant_privileges_to_account_role" "grant_usage_stage_to_airflow_role" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.airflow_role.name
  on_schema_object {
    object_type = "STAGE"
    object_name = "${snowflake_schema.staging.fully_qualified_name}.${snowflake_stage_external_s3.achs_s3_stage.name}"
  }
}


