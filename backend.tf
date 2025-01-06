terraform {
  backend "s3" {
    bucket         = "peritus-bucket" 
    key            = "static-website/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}