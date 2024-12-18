resource "aws_security_group" "elb-sg" {
    name = var.project-name
    description = "Allow all inbound traffic"
    vpc_id = var.test_vpc
    
    # Ingress for HTTP
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Ingress for HTTPS
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Egress for all outbound tarffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = var.project-name
    }
}