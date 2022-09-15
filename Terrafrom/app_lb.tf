
resource "aws_alb" "app-public-lb" {
  name            = join("-", ["app-public-lb", var.company])
  security_groups = ["${aws_security_group.http-access-sg.id}"]
  subnets         = ["${aws_subnet.public-subnet.id}", "${aws_subnet.public-subnet2.id}"]
  tags = {
    Name = join("-", ["app-public-lb", var.company])
  }
}


resource "aws_lb_target_group" "wp-tg" {
  name        = join("-", ["wp-tg", var.company])
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.aws-vpc.id
  target_type = "ip"
  tags = {
    Name = join("-", ["wp-tg", var.company])
  }
}

resource "aws_lb_listener" "wp_http_listener" {
  load_balancer_arn = aws_alb.app-public-lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.wp-tg.id
    type             = "forward"
  }
  tags = {
    Name = join("-", ["aws-lb-wp-listener", var.company])
  }
}