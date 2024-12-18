resource "aws_lb" "porkersaint_elb-dev" {
    internal = false
    subnets = var.subnets_ids
    security_groups = [var.elb_security_group_id]
    load_balancer_type = "application"
    enable_deletion_protection = false
    tags = {
        Name = var.elb_name
    }
}    

#target group attachment
resource "aws_lb_target_group_attachment" "porkersaint_elb-dev" {
    target_group_arn = var.http
    target_id = var.ec2_instance
    port = 80
}

#attach listener to target group 443
resource "aws_lb_listener" "porkersaint_elb-dev-443" {
    load_balancer_arn = aws_lb.porkersaint_elb-dev.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
    certificate_arn = var.certificate_arn
    default_action {
        type = "forward"
        target_group_arn = var.http
    }
}

#attach listener 80 redirect to 443
resource "aws_lb_listener" "porkersaint_elb-dev-80" {
    load_balancer_arn = aws_lb.porkersaint_elb-dev.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "redirect"
        redirect {
            host = "#{host}"
            path = "/#{path}"
            port = 443
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}