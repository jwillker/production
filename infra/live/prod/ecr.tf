# ECR Repository

resource "aws_ecr_repository" "discounts" {
  name = "app-discounts"
}

resource "aws_ecr_repository" "products" {
  name = "app-products"
}

resource "aws_ecr_repository" "database" {
  name = "app-database"
}
