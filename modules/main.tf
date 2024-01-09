variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_vpc" {}
variable "aws_subnet" { }

provider "aws" {
  region = "us-east-1"  
  
}

provider "vault" {
    address = "http://54.86.94.139:8200"
    skip_child_token = true

    auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "fe5643d2-4123-a8ee-561e-eaa85b5168bc"
      secret_id = "81769025-d07f-acdb-dc3e-2f0343b0c260"
    }
  }
  
}

data "vault_kv_secret_v2" "dev" {
  mount = "kv" 
  name  = "dev-secret" 
}


module "my_vpc" {
  source      =  "/workspaces/ECF3_SECU_INFRA/modules/vpc"   #"../modules/vpc"
  vpc_cidr    = "192.168.0.0/16"
  tenancy     = "default"
  vpc_id      = module.my_vpc.vpc_id
  subnet_cidr = "192.168.1.0/24"
}

module "my_ec2" {
  source        = "/workspaces/ECF3_SECU_INFRA/modules/ec2"  #../modules/ec2"
  ec2_count     = 1
  ami_id        = "ami-5a8da735"
  instance_type = "t2.micro"
  subnet_id     = module.my_vpc.subnet_id
}
