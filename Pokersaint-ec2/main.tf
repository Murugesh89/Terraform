resource "aws_instance" "ubuntu22" {
    ami = var.ami_id
    instance_type = var.instance_fam
    subnet_id = var.subnet_ids[0]
    vpc_security_group_ids = [var.instance-sg_id]
    tags = { 
        Name = var.instance_name
    }
   
    root_block_device {
      volume_size = var.volume_size
      volume_type = "gp3"
      iops = 3000
      throughput = 150
      delete_on_termination = true
    }
}