terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws"   {
  region  = "us-east-1"

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block
  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-public-subnet-1"
  }
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-webserver" {
  source = "./modules/webserver"
  image_regex = var.image_regex
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  my_ip = var.my_ip
  instance_type = var.instance_type
  ssh_public_key_path = var.ssh_public_key_path
}