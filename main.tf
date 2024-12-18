data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "subnets" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
}
data "aws_subnet" "subnets2" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1b"
}
data "aws_subnet" "subnets3" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1c"
}
module "EC2" {
  source         = "./Pokersaint-ec2"
  subnet_ids     = [data.aws_subnet.subnets.id, data.aws_subnet.subnets2.id, data.aws_subnet.subnets3.id]
  ami_id         = "ami-005fc0f236362e99f"
  instance_fam   = "t2.micro"
  instance-sg_id = module.EC2-SG.instance-sg
  volume_size    = 8
  instance_name  = "Pokersaint-Instance-DEV"
}
module "EC2-SG" {
  source       = "./Instanec-sg"
  test_vpc     = data.aws_vpc.default.id
  project-name = "Pokersaint-Instance-dev-SG"
}
module "ALB" {
  source                = "./Loadbalancer"
  subnets_ids           = [data.aws_subnet.subnets.id, data.aws_subnet.subnets2.id, data.aws_subnet.subnets3.id]
  elb_security_group_id = module.ELB-SG.elb-security
  ec2_instance          = module.EC2.ec2-instance
  elb_name              = "Pokersaint-elb-dev-elb"
  http                  = module.TARGET-GROUP.target_group
  certificate_arn       = module.Certificate.aws_certificate
}
module "ELB-SG" {
  source       = "./Elb-SG"
  test_vpc     = data.aws_vpc.default.id
  project-name = "Pokersaint-elb-dev-SG"
}
module "TARGET-GROUP" {
  source       = "./Targetgroup"
  test_vpc     = data.aws_vpc.default.id
  project-name = "Pokersaint-elb-dev-TG"
}
module "Certificate" {
  source       = "./ACM"
  domain_name  = "jrdevops.today"
  alternative_name = "*.jrdevops.today"
  project-name = "Pokersaint-acm-dev"
}
module "Rout53" {
  source             = "./Route53"
  domain_name        = "jrdevops.today"
  primary_name       = "test.jrdevops.today"
  secondary_name     = "test1.jrdevops.today"
  domain_destination = module.ALB.elb-name
  webserver_ip       = module.EC2.public-ip
}
terraform {
  backend "s3" {
    bucket = "terra-form-statefile-store"
    key    = "terraform.tfstate"
    region = "us-east-1"
    profile = "terraform-admin"
  }
}