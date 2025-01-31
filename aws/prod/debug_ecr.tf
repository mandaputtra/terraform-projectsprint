# https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/latest
module "debug_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  for_each = toset(var.debug_services)

  repository_name                   = "debug-${each.value}"
  repository_type                   = "public"
  repository_image_tag_mutability   = "MUTABLE"
  repository_force_delete           = true
  repository_read_write_access_arns = [module.projectsprint_iam_account["debug"].iam_user_arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  providers = {
    aws = aws.us-east-1
  }

  tags = {
    project = "projectsprint",
    Name    = "debug-db"
  }
}
