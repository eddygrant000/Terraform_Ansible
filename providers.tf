provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "eddygrant000"
    region = "ap-south-1"
    key = "testenv/terraform.tfstate"
  }
}

resource "aws_key_pair" "ct-keypair" {
    key_name = "ct-keypair"
    public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
    # public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
}
