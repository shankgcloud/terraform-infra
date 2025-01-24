provider "aws" {
  region = var.region
}

# Configuring remote backend with s3

terraform {
  backend "s3" {
    bucket = "mybucket"     # Add the name of the bucket here
    key    = "path/to/my/key"     # the key will typically be the state file name "terraform.tfstate"
    region = "us-east-1"

    # You may also add the dynamoDB table details to implement state locking
  }
}
