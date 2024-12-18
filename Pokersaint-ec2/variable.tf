variable "ami_id" {}
variable "instance_fam" {}
variable "instance-sg_id" {
  type = string
}
variable "subnet_ids" {
  description = "subnet_ids"
  type = list(string)
}
variable "instance_name" {}
variable "volume_size" {
  type = number
}