#Cria NLB
resource "aws_lb" "stephanie" {  
  name               = "nlb-stephanie"
  internal           = true
  load_balancer_type = "network"
  subnets            = ["${var.subnet_id}"]
  enable_deletion_protection = false
}

#Cria o TG-Group pra responder apenas na porta 80
resource "aws_lb_target_group" "tg-stephanie" {   
  name     = "tg-stephanie"
  port     = "80"
  protocol = "TCP"
  vpc_id   = var.vpc_id
  target_type = "instance"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

#Cria Listener
resource "aws_lb_listener" "stephanie" {  
  load_balancer_arn = aws_lb.stephanie.arn
  port              = "80"
  protocol          = "TCP"
 
  default_action {
    type          = "forward"
    target_group_arn = aws_lb_target_group.tg-stephanie.arn
  
 }
}

#Cria TG-Attachment 
resource "aws_lb_target_group_attachment" "tga-stephanie" {   
  target_group_arn = aws_lb_target_group.tg-stephanie.arn
  target_id = aws_instance.ec2-stephanie.id
  port = 80
}

#EP Service
resource "aws_vpc_endpoint_service" "eps-stephanie" {  
  acceptance_required = true
  network_load_balancer_arns = [aws_lb.stephanie.arn]
}
