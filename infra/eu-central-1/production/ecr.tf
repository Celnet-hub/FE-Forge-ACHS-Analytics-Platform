resource "aws_ecr_repository" "achs_dbt_repo" {
  name                 = "achs-dbt"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "achs-dbt" })
}
