terraform {
  backend "s3" {
    bucket                      = "<your-terraform-state-space-name>" # give the same name of your space 
    key                         = "terraform/k8s-cluster/terraform.tfstate"
    region                      = "us-east-1"
    endpoints = {
      s3 = "https://<your_bucket_region>.digitaloceanspaces.com"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id = true   
    use_path_style              = true
  }
}
