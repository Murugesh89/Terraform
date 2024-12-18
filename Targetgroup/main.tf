resource "aws_lb_target_group" "pokersaint-dev" {
    name = "webserver"
    target_type = "instance"
    port = 80
    protocol = "HTTP"
    vpc_id = var.test_vpc

    health_check {
      enabled = true
      interval = 30
      path = "/"
      port = "traffic-port"
      protocol = "HTTP"
      matcher = "200"
      timeout = 5
      healthy_threshold = 5

    }
    tags = {
      Name = var.project-name
    }
}
