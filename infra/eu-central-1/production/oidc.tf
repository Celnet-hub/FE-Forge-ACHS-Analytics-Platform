resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # Standard GitHub Actions thumbprint
}

resource "aws_iam_role" "github_actions_role" {
  name = "achs-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_oidc.arn
        }
        Condition = {
          StringEquals = {
            # STRICT SECURITY - Only allow specific repository to assume this role
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:Celnet-hub/FE-Forge-ACHS-Analytics-Platform:*"
          }
        }
      }
    ]
  })
}


# POLICY 1 - Amazon ECR Push Permissions
resource "aws_iam_policy" "github_ecr_push_policy" {
  name        = "achs_github_ecr_push"
  description = "Allows GitHub Actions to authenticate and push to the dbt ECR repo"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # GetAuthorizationToken cannot be scoped to a specific resource
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        # Strictly scoped to your specific achs-dbt-core repository
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = aws_ecr_repository.achs_dbt_repo.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ecr_push" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_ecr_push_policy.arn
}


# POLICY 2 - Terraform State Management On S3
resource "aws_iam_policy" "github_tf_state_policy" {
  name        = "achs_github_tf_state"
  description = "Allows GitHub Actions to read/write Terraform state and manage locks"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Permissions for the S3 State Bucket
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::fed-engr-dubem-terraform-state",
          "arn:aws:s3:::fed-engr-dubem-terraform-state/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_tf_state" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_tf_state_policy.arn
}