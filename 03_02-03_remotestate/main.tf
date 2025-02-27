# //////////////////////////////
# BACKEND
# //////////////////////////////
terraform {
  backend "s3" {
  }
}

# //////////////////////////////
# VARIABLES
# //////////////////////////////
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet1_cidr" {
  default = "172.16.0.0/24"
}

#variable "vpc_tags" {
#  default = "environment = terraform-jenkins-shan"  
#}

# //////////////////////////////
# PROVIDERS
# //////////////////////////////
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}


# //////////////////////////////
# MODULES
# //////////////////////////////
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-module-example-shan"

  cidr = "10.0.0.0/16"

#  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  azs             = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1],data.aws_availability_zones.available.names[2]]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  #tags = "environment" = "terraform_jenkins_shan"
  #tags = var.vpc_tags

}


# //////////////////////////////
# DATA
# //////////////////////////////

data "aws_availability_zones" "available" {}

