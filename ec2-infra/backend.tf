terraform {
  backend "s3" {
    bucket = "project-dr-637423436093"
    key    = "state/ec2-infra.tfstate"
    region = "ap-south-1"
  }
}