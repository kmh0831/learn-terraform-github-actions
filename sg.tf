resource "aws_security_group_rule" "cicd_sg_ingress_internal" {
  type               = "ingress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"
  source_security_group_id = aws_security_group.cicd_sg.id
  security_group_id  = aws_security_group.cicd_sg.id
}