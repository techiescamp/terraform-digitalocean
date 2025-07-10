terraform {
  backend "s3" {
    bucket                      = "my-terraform-state" # unique name for the space
    key                         = "terraform/k8s-cluster/terraform.tfstate"
    region                      = "us-east-1"
    endpoints = {
      s3 = "https://blr1.digitaloceanspaces.com"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id = true   
    use_path_style              = true
  }
}
