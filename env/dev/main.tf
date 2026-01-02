module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  az                  = "us-east-1a"
}

module "ec2" {
  source        = "../../modules/ec2"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  instance_type = "t3.micro"
  key_name      = var.key_name
}

module "ebs" {
  source      = "../../modules/ebs"
  instance_id = module.ec2.instance_id
  az          = module.ec2.az
}

