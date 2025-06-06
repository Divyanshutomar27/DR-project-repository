# backend state #
terraform {
  backend "s3" {
    bucket = "project-dr-637423436093"
    key    = "state/vpc-infra.tfstate"
    region = "ap-south-1"
  }
}