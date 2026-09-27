resource "snowflake_database" "achs_analytics" {
  name    = "ACHS_ANALYTICS"
  comment = "Single Source of Truth for ACHS BI"
}


resource "snowflake_schema" "staging" {
  database = snowflake_database.achs_analytics.name
  name     = "STAGING"
  comment  = "Raw data landing zone for nested JSON objects"
}


resource "snowflake_schema" "silver" {
  database = snowflake_database.achs_analytics.name
  name     = "SILVER"
  comment  = "Cleaned and standardized healthcare entities"
}


resource "snowflake_schema" "gold" {
  database = snowflake_database.achs_analytics.name
  name     = "GOLD"
  comment  = "Star schema containing fact and dimension tables"
}


resource "snowflake_warehouse" "dbt_compute" {
  name                      = "ACHS_DBT_WH"
  warehouse_size            = "X-SMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
}
