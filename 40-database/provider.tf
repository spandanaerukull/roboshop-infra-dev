terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.98.0"
    }
  }


  backend "s3" {    
    bucket = "84-remote-state-dev"  # Specify the S3 bucket to store the Terraform state file
    # Ensure that the bucket exists before running Terraform
    key    = "roboshop-dev-db"  # This key is used to store the state file in the specified S3 bucket
    region = "us-east-1"
    encrypt = true
    use_lockfile = true    # Enable state locking to prevent concurrent modifications 

  }

}

provider "aws" {
  # Configuration options
    region = "us-east-1"  # Specify the AWS region to use
}
  
