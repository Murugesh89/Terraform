variable "elb_security_group_id" {
  type = string
}
variable "elb_name" {}
variable "http" {}
variable "ec2_instance" {}
variable "subnets_ids" {
  type = list(string)
}
variable "certificate_arn" {}