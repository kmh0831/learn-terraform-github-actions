# ALB 생성
resource "aws_lb" "alb"{
  name = "Terrform-ALB"
  internal = false	 # true = 내부(internal) / false = 외부(Internet-facing)
  load_balancer_type = "application" # Default - application, 다른 하나는 gateway
  security_groups = [aws_security_group.allow_http.id]
  subnets = [aws_subnet.publict-sub-1.id, aws_subnet.publict-sub-2.id]
  depends_on = [aws_instance.web_2] # AppEC2 완전 생성 후 ALB 생성 시작
  tags = {
      Name = "ALB"
  }
}

# ALB Target Groups
resource "aws_lb_target_group" "alb-tg"{
  name    = "ALB-TG"
  port    = "80"
  protocol   = "HTTP"
  vpc_id  = aws_vpc.vpc-1.id
  target_type = "instance"
  
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = {
      Name = "alb-tg"
  }
}

# ALB listener
resource "aws_lb_listener" "alb-listner"{
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

# 구성한 ALB에 attach할 대상 지정 (원본 인스턴스 Attach)
  # aws_lb_target_group_attachment의 경우 기존 원본 EC2 또는, 컨테이너, 람다 대상으로만 지정 가능
    # ASG에서 생성 된 인스턴스의 경우 aws_autoscaling_group에서 매개변수를 사용하여 타겟 그룹에 등록해야함
resource "aws_lb_target_group_attachment" "internal-alb-attach-resource-1"{
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.web_1.id
  port = 80
  depends_on = [aws_lb_listener.alb-listner]
}
# 만약 위 방식으로 ASG에서 생성된 인스턴스들의 Target_id를 별도로 지정 시, 에러 발생

resource "aws_lb_target_group_attachment" "internal-alb-attach-resource-2"{
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.web_2.id
  port = 80
  depends_on = [aws_lb_listener.alb-listner]
}