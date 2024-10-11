#-------------------------------------------------<ECS Service Security Group>--------------------------------------------------
resource "aws_security_group" "ecs_svc_sg" {
  name        = "github-runner-ecs-svc-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "github-runner-ecs-svc-sg"
  }
}
