terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-blogplatform-22"
    key            = "state/terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "my-terraform-state-bucket-blogplatform-22"
    encrypt        = true
  }
}
