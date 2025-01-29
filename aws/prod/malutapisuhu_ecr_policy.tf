# https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-policy
module "malutapisuhu_ecr_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.37.1"

  name = "malutapisuhu-ecr-${random_string.malutapisuhu_ecr_policy_suffix.result}"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:*"
        ]
        Resource = [
          for service in var.malutapisuhu_services :
          module.malutapisuhu_ecr[service].repository_arn
        ]
      },
    ]
  })
  tags = {
    project     = "projectsprint"
    environment = "development"
    team_name   = "malutapisuhu"
  }
}
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "malutapisuhu_ecr_policy_suffix" {
  length  = 4
  special = false
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment
resource "aws_iam_user_policy_attachment" "malutapisuhu_ecr_policy" {
  user       = module.projectsprint_iam_account["malu-malu-tapi-suhu"].iam_user_name
  policy_arn = module.malutapisuhu_ecr_policy.arn
}
