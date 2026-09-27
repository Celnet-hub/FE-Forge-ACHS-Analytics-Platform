resource "snowflake_storage_integration_aws" "achs_s3_integration" {
  name             = "ACHS_S3_INTEGRATION"
  comment          = "Storage integration for ACHS raw JSON dumps"
  enabled          = true
  storage_provider = "S3"
  # Constructed manually (not a resource reference) to avoid a dependency cycle with aws_iam_role.snowflake_role
  storage_aws_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/snowflake-role"
  storage_allowed_locations = ["s3://ach-data-project/"]
}


# Create the JSON File Format for the raw data
resource "snowflake_file_format_json" "json_format" {
  name              = "ACHS_JSON_FORMAT"
  database          = snowflake_database.achs_analytics.name
  schema            = snowflake_schema.staging.name
  strip_outer_array = true
}

# Create the External Stage
resource "snowflake_stage_external_s3" "achs_s3_stage" {
  name                = "ACHS_RAW_DATA_STAGE"
  database            = snowflake_database.achs_analytics.name
  schema              = snowflake_schema.staging.name
  storage_integration = snowflake_storage_integration_aws.achs_s3_integration.name
  url                 = "s3://ach-data-project/"
  comment             = "Fully configured S3 external stage"
}