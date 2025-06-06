terraform {
  backend "s3" {
    bucket = "project-dr-637423436093"
    key    = "project-dr-637423436093/state/vpc-endpoint-infra.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}