terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "static_website" {
  source = "../../modules/s3-static-website"

  bucket_name = "my-static-website-${var.environment}"
  environment = var.environment
  
  tags = {
    Project     = "Static Website"
    Environment = var.environment
  }
}